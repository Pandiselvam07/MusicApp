
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DATABASE_URL = 'postgresql://postgres.itpvdgiyhabqsrbtagnj:[YOUR-PASSWORD]@aws-0-ap-south-1.pooler.supabase.com:6543/postgres'

engine = create_engine(DATABASE_URL)

SessionLocal =sessionmaker(autocommit =False,autoflush=False, bind=engine)

def get_db():
  
  db = SessionLocal()
  try :
    yield db
  finally :
    db.close()
  