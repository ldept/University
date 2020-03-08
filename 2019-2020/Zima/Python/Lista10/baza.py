from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Table, Column, Integer, Boolean, ForeignKey, String, DateTime
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
import argparse
from argh import *
import sys
import datetime

engine = create_engine('sqlite:///books.db', echo=False)
Session = sessionmaker(bind=engine)


Base = declarative_base()

class Book(Base):
    __tablename__ = 'Book'
    id = Column(Integer, primary_key=True)
    title = Column(String(50), nullable=False)
    author = Column(String(50), nullable=False)
    year = Column(Integer, nullable=False)
    def __str__(self):
        output = ''
        for c in self.__table__.columns:
            output += '{}: {} | '.format(c.name, getattr(self, c.name))
        return output

class Friend(Base):
    __tablename__ = 'Friend'
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False)
    email = Column(String(50), nullable=False)
    def __str__(self):
        output = ''
        for c in self.__table__.columns:
            output += '{}: {} | '.format(c.name, getattr(self, c.name))
        return output    
    

class Rent(Base):
    __tablename__ = 'Rent'
    date = Column(DateTime, default=datetime.datetime.utcnow, primary_key=True)
    book_id = Column(Integer, ForeignKey('Book.id'), nullable=False)
    friend_id = Column(Integer, ForeignKey('Friend.id'), nullable=False)
    returned = Column(Boolean, nullable=False, default=False)
    def __str__(self):
        output = ''
        for c in self.__table__.columns:
            output += '{}: {} | '.format(c.name, getattr(self, c.name))
        return output

if engine.dialect.has_table(engine, 'Book'):
    Base.metadata.create_all(engine)



if __name__ == "__main__":
    sesja = Session()

    # parser = argparse.ArgumentParser()
    # parser.parse_args()
    # parser.add_argument('--column', help='database column')
    
    # subparsers = parser.add_subparsers(help='help for subcommand')

    # parser_add = subparsers.add_parser('add', help='add another entry to column')
    # parser_del = subparsers.add_parser('del', help='delete entry from column')
    # parser_del.add_argument('--column')
    # parser_show = subparsers.add_parser('show', help='show all entries in column')
    # parser_show.add_argument('--column', help='name of the column')

    # args = parser.parse_args()
    if sys.argv[1] == 'Book':
        if sys.argv[2] == 'dodaj':
            sesja.add(Book(title=sys.argv[3], author=sys.argv[4], year=sys.argv[5]))
        elif sys.argv[2] == 'wypisz':
            for item in sesja.query(Book).all():
                print(item)
            
    elif sys.argv[1] == 'Friend':
        if sys.argv[2] == 'dodaj':
            sesja.add(Friend(name=sys.argv[3], email=sys.argv[4]))
        elif sys.argv[2] == 'wypisz':
            for item in sesja.query(Friend).all():
                print(item)
    elif sys.argv[1] == 'Rent':
        if sys.argv[2] == 'dodaj':
            if len(sesja.query(Rent).filter(Rent.book_id == sys.argv[3], Rent.friend_id == sys.argv[4], Rent.returned == False).all()):
                print('Ksiazka juz wypozyczona wez sobie inna')
            else:
                sesja.add(Rent(book_id=sys.argv[3], friend_id=sys.argv[4]))

        elif sys.argv[2] == 'oddaj':
            rent = sesja.query(Rent).filter(Rent.book_id == sys.argv[3], Rent.friend_id == sys.argv[4], Rent.returned == False).first()
            rent.returned = True
        elif sys.argv[2] == 'wypisz':
            for item in sesja.query(Rent).all():
                print(item)
    
    # print('\n')
    sesja.commit()
    sesja.close()