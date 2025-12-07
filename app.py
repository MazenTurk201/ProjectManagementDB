from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from datetime import datetime

from sqlalchemy import func

app = Flask(__name__)
app.secret_key = 'super_secret_key'  # مهم جداً عشان الـ Login يشتغل

# إعدادات الداتا بيز
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/ProjectManagementDB_Schema'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# ===========================
# 1. Models (الجداول)
# ===========================

# جدول الموظفين (هو هو اليوزر)
class Team_Member(UserMixin, db.Model):
    __tablename__ = 'Team_Member'
    Member_ID = db.Column(db.Integer, primary_key=True)
    Full_Name = db.Column(db.String(255))
    Hourly_Rate = db.Column(db.Integer)
    Manager_ID = db.Column(db.Integer)
    Email = db.Column(db.String(255), unique=True)
    Password = db.Column(db.String(255))
    Role = db.Column(db.String(100), default='Member')
    Is_Active = db.Column(db.Boolean, default=True)
    # ============================

    def get_id(self):
        return (self.Member_ID)

# جدول التاسكات
class Task(db.Model):
    __tablename__ = 'Task'
    Task_ID = db.Column(db.Integer, primary_key=True)
    Project_ID = db.Column(db.Integer) # بنبسط الدنيا مش لازم علاقات معقدة دلوقتي
    Milestone_ID = db.Column(db.Integer)
    Title = db.Column(db.String(255))
    Description = db.Column(db.Text)
    Start_Date = db.Column(db.Date)
    End_Date = db.Column(db.Date)
    Priority = db.Column(db.String(50))
    Status = db.Column(db.String(50)) 
    Task_Type = db.Column(db.String(50))
    Estimated_Hours = db.Column(db.Float)
    Actual_Hours = db.Column(db.Float)
    Created_By = db.Column(db.Integer)

# جدول المشاريع
class Project(db.Model):
    __tablename__ = 'Project'
    Project_ID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(255), nullable=False)
    Description = db.Column(db.Text)
    Start_Date = db.Column(db.Date, nullable=False)
    End_Date = db.Column(db.Date)
    Status = db.Column(db.String(50), default='Active')
    Budget = db.Column(db.Numeric(12, 2))
    Updated_At = db.Column(db.DateTime, default=datetime.now)

    @property
    def progress(self):
        # 1. بنادي على التاسكات الخاصة بالمشروع ده (self.Project_ID)
        total = Task.query.filter_by(Project_ID=self.Project_ID).count()
        
        # 2. لو مفيش تاسكات رجع صفر عشان القسمة
        if total == 0:
            return 0
            
        # 3. احسب المكتمل
        completed = Task.query.filter_by(Project_ID=self.Project_ID, Status='Completed').count()
        
        # 4. رجع النسبة
        return int((completed / total) * 100)

# جدول الميلستونز
class Milestone(db.Model):
    __tablename__ = 'milestone'
    Milestone_ID = db.Column(db.Integer, primary_key=True)
    Project_ID = db.Column(db.Integer)
    Name = db.Column(db.String(255), nullable=False)
    Due_Date = db.Column(db.Date)
    Description = db.Column(db.Text)

# جدول الكومنتات
class Comment(db.Model):
    __tablename__ = 'comment'
    Comment_ID = db.Column(db.Integer, primary_key=True)
    Task_ID = db.Column(db.Integer)
    Member_ID = db.Column(db.Integer)
    Content = db.Column(db.String(255), nullable=False)
    Comment_Type = db.Column(db.Text)

# جدول ال Member_Task
class Member_Task(db.Model):
    __tablename__ = 'Member_Task'
    Member_Task_ID = db.Column(db.Integer, primary_key=True)
    Member_ID = db.Column(db.Integer)
    Task_ID = db.Column(db.Integer)
    Role_In_Task = db.Column(db.String(255), nullable=False)
    Is_Primary_Assignee = db.Column(db.Boolean, default=False)
# ===========================
# 2. Login Logic
# ===========================

@login_manager.user_loader
def load_user(user_id):
    return Team_Member.query.get(int(user_id))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        user = Team_Member.query.filter_by(Email=email).first()
        
        # بنتشيك لو اليوزر موجود والباسورد صح (هنا مقارنة بسيطة للتسهيل)
        if user and user.Password == password:
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            flash('الإيميل أو الباسورد غلط يا ريس!')
            
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# ===========================
# 3. Task Management (CRUD)
# ===========================

@app.route('/')
@app.route('/dashboard')
@login_required
def dashboard():
    # هات كل التاسكات
    tasks = Task.query.all()
    completed_tasks = Task.query.filter_by(Status='Completed').count()
    pending_tasks = Task.query.filter_by(Status='Pending').count()
    projects = Project.query.all()
    total_tasks = Task.query.count()
    total_milestones = Milestone.query.count()
    return render_template('dashboard.html', tasks=tasks, name=current_user.Full_Name, completed_tasks=completed_tasks, pending_tasks=pending_tasks, projects=projects, total_tasks=total_tasks, total_milestones=total_milestones,)

@app.route('/add_project', methods=['POST'])
@login_required
def add_project():
    name = request.form['project-name']
    budget = request.form['project-budget']
    desc = request.form['description']
    due_date = request.form['due-date']
    status = request.form['status']
    # بنحط قيم افتراضية للتاريخ والمشروع للتسهيل
    new_project = Project(Name=name, Description=desc, Status=status, Start_Date=datetime.now(), End_Date=due_date, Budget=budget, Updated_At=datetime.now())
    db.session.add(new_project)
    db.session.commit()
    return redirect(url_for('dashboard'))

@app.route('/add_task', methods=['POST'])
@login_required
def add_task():
    title = request.form['title']
    desc = request.form['description']
    due_date = request.form['due_date']
    priority = request.form['priority']
    projectid = request.form['project_id']
    # بنحط قيم افتراضية للتاريخ والمشروع للتسهيل
    new_task = Task(Title=title, Description=desc, Status='Pending', Project_ID=projectid, Start_Date=datetime.now(), End_Date=due_date, Priority=priority, Created_By=current_user.Member_ID, Task_Type='Development', Estimated_Hours=0, Actual_Hours=0)
    db.session.add(new_task)
    db.session.commit()
    return redirect(url_for('dashboard'))

@app.route('/add_milstone', methods=['POST'])
@login_required
def add_milstone():
    name = request.form['milestone-name']
    desc = request.form['description']
    due_date = request.form['due-date']
    project_id = request.form['project-id']
    linktasks = request.form['link-tasks']
    # بنحط قيم افتراضية للتاريخ والمشروع للتسهيل
    # new_milstone = Milestone(Name=name, Description=desc, linktasks=linktasks, End_Date=due_date)
    new_milstone = Milestone(Project_ID=project_id, Name=name, Description=desc, Due_Date=due_date)
    db.session.add(new_milstone)
    db.session.commit()
    return redirect(url_for('milestones'))

@app.route('/delete_task/<int:id>')
@login_required
def delete_task(id):
    task = Task.query.get_or_404(id)
    try:
        db.session.delete(task)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        flash('حدث خطأ أثناء الحذف.')
        print(e)
    return redirect(url_for('dashboard'))

@app.route('/delete_project/<int:id>')
@login_required
def delete_project(id):
    project = Project.query.get_or_404(id)
    db.session.commit()
    try:
        db.session.delete(project)
        db.session.commit()
        flash('تم حذف المشروع بنجاح! 🗑️')
    except Exception as e:
        db.session.rollback()
        flash('حدث خطأ أثناء الحذف.')
        print(e)
    return redirect(url_for('dashboard'))

@app.route('/update_task/<int:id>')
@login_required
def update_task(id):
    # زرار بيقلب الحالة من Pending لـ Completed والعكس (سريع)
    task = Task.query.get_or_404(id)
    if task.Status == 'Pending':
        task.Status = 'Completed'
    else:
        task.Status = 'Pending'
    db.session.commit()
    return redirect(url_for('dashboard'))

# app.py

@app.route('/update_project/<int:id>', methods=['POST'])
@login_required
def update_project(id):
    # 1. هات المشروع من الداتا بيز
    project = Project.query.get_or_404(id)
    
    if request.method == 'POST':
        # 2. خد البيانات الجديدة من الفورم
        project.Name = request.form['name']
        project.Description = request.form['description']
        # (ممكن تزود Status أو Date لو حاططهم في الفورم)
        
        try:
            # 3. احفظ التغييرات
            db.session.commit()
            flash('تم تعديل بيانات المشروع بنجاح! ✨')
        except:
            db.session.rollback()
            flash('حصلت مشكلة أثناء التعديل ❌')
            
        return redirect(url_for('dashboard'))

# app.py

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        full_name = request.form['full_name']
        email = request.form['email']
        password = request.form['password']
        
        # 1. نتأكد إن الإيميل مش متسجل قبل كده
        existing_user = Team_Member.query.filter_by(Email=email).first()
        
        if existing_user:
            flash('الإيميل ده متسجل قبل كده يا هندسة، جرب تعمل Login!')
            return redirect(url_for('signup'))
        
        # 2. نجهز اليوزر الجديد
        # (Role='Member') حطينا دور افتراضي عشان الداتا بيز متضربش
        new_user = Team_Member(
            Full_Name=full_name, 
            Email=email, 
            Password=password, 
            Role='Member',  
            Is_Active=True
        )
        
        # 3. نحفظ في الداتا بيز
        db.session.add(new_user)
        db.session.commit()
        
        flash('تم التسجيل بنجاح! تقدر تدخل دلوقتي.')
        return redirect(url_for('login'))

    return render_template('signup.html')

@app.route('/projects')
@login_required
def projects():
    # هات كل التاسكات
    project = Project.query.all()
    mailstone = Milestone.query.all()
    last_project = Project.query.order_by(Project.Project_ID.desc()).first()
    # 1. هات عدد التاسكات الكلي
    total_tasks = Task.query.count()
    
    # 2. هات عدد التاسكات اللي خلصت (Completed)
    completed_tasks = Task.query.filter_by(Status='Completed').count()
    
    # 3. احسب النسبة (مع حماية عشان لو مفيش تاسكات القسمة على صفر متضربش)
    project_progress = 0
    if total_tasks > 0:
        project_progress = int((completed_tasks / total_tasks) * 100)
    return render_template('projects.html', project=project, name=current_user.Full_Name, mailstone=mailstone, last_project=last_project, project_progress=project_progress, total_tasks=total_tasks)

# app.py

# الدالة دي بتشتغل قبل أي صفحة تفتح
@app.context_processor
def inject_global_data():
    # بنتشيك الأول إن اليوزر عامل login عشان ميحصلش error
    if current_user.is_authenticated:
        # هات كل المشاريع عشان القائمة المنسدلة
        my_projects = Project.query.all()
    else:
        my_projects = []
        
    # رجع قاموس (Dictionary) فيه الحاجات اللي عايزها تظهر في كل حتة
    return dict(projects_list=my_projects)

@app.route('/tasks')
@login_required
def task():
    # هات كل التاسكات
    tasks = Task.query.all()
    projects = Project.query.all()
    total_tasks = Task.query.count()
    total_project_budget = Task.query.with_entities(func.sum(Project.Budget)).scalar() or 0
    milestone = Milestone.query.all()
    completed_tasks = Task.query.filter_by(Status='Completed').count()
    project_progress = 0
    if total_tasks > 0:
        project_progress = int((completed_tasks / total_tasks) * 100)
    return render_template('project_tasks.html', tasks=tasks, name=current_user.Full_Name, total_project_budget=total_project_budget, total_tasks=total_tasks, milestones=milestone, project_progress=project_progress, projects=projects, completed_tasks=completed_tasks)

# فلتر سحري بيجيب اسم المشروع بمعلومية الـ ID بتاعه
@app.template_filter('get_project_name')
def get_project_name_filter(project_id):
    if not project_id:
        return "غير محدد"
    
    # دور على المشروع في الداتا بيز
    project = Project.query.get(project_id)
    
    # لو لقاه رجع اسمه، لو ملقاهوش رجع "غير معروف"
    return project.Name if project else "مشروع محذوف"

@app.route('/team_members')
@login_required
def team_members():
    team_members = Team_Member.query.all()
    total_members = Team_Member.query.count()
    query = request.args.get('q')

    if query:
        # 2. لو فيه بحث، فلتر بالاسم أو الإيميل (ILIK for case-insensitive search if supported, otherwise use like)
        # استخدمنا or_ عشان يبحث في الاتنين
        from sqlalchemy import or_
        team_members = Team_Member.query.filter(
            or_(
                Team_Member.Full_Name.ilike(f'%{query}%'),
                Team_Member.Email.ilike(f'%{query}%')
            )
        ).all()
    else:
        # 3. لو مفيش بحث، هات كله
        team_members = Team_Member.query.all()
    return render_template('team_members.html', team_members=team_members, name=current_user.Full_Name, total_members=total_members)

@app.route('/reports')
@login_required
def reports():
    tasks = Task.query.all()
    return render_template('report.html', tasks=tasks, name=current_user.Full_Name)

@app.route('/milestones')
@login_required
def milestones():
    tasks = Task.query.all()
    milestones = Milestone.query.all()
    return render_template('milestone.html', name=current_user.Full_Name, milestones=milestones, tasks=tasks)

@app.route('/project/<int:id>/tasks') # أو اسم اللينك اللي أنت عامله
@login_required
def project_tasks(id):
    project = Project.query.get_or_404(id)
    milestones = Milestone.query.filter_by(Project_ID=id).all()
    
    # حسبة الـ Progress Bar
    total_tasks = Task.query.filter_by(Project_ID=id).count()
    completed_tasks = Task.query.filter_by(Project_ID=id, Status='Completed').count()
    
    progress = 0
    if total_tasks > 0:
        progress = int((completed_tasks / total_tasks) * 100)
        
    return render_template('task_detail.html', 
                         project=project, 
                         milestones=milestones, 
                         progress=progress,
                         total_tasks=total_tasks)

if __name__ == '__main__':
    app.run(debug=True)