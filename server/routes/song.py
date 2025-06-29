import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile
from models.favorite import Favorite
from models.song import Song
from database import get_db
from sqlalchemy.orm import Session ,joinedload
from middleware.auth_middleware import auth_middleware
from pydantic_schemas.favorite_song import FavoriteSong


router =APIRouter()

cloudinary.config( 
    cloud_name = "ddlinxe9x", 
    api_key = "337746196766851", 
    api_secret = "1TUsRFDVA9nQg9gemfdxqn1QvsY", 
    secure=True
)

@router.post('/upload',status_code=201)
def upload_song(song:UploadFile = File(...),thumbnail:UploadFile=File(...),artist:str=Form(...),song_name:str=Form(...),hex_code:str=Form(...),db:Session=Depends(get_db),auth_dict=Depends(auth_middleware),):
  
  song_id =str(uuid.uuid4())
  song_res = cloudinary.uploader.upload(song.file,resource_type='auto',folder=f'songs/{song_id}') 
  print(song_res['url'])
  thumbnail_res = cloudinary.uploader.upload(thumbnail.file,resource_type='image',folder=f'songs/{song_id}') 
  print(thumbnail_res['url'])
  new_song = Song(id=song_id,song_name=song_name,artist=artist,hex_code=hex_code,song_url=song_res['url'],thumbnail_url=thumbnail_res['url'])

  db.add(new_song)
  db.commit()
  db.refresh(new_song)
  return new_song

@router.get('/list')
def list_songs(db:Session=Depends(get_db),auth_dict=Depends(auth_middleware)):
  song =db.query(Song).all()
  return song

@router.post('/favorite')
def favorite_song(song:FavoriteSong,db:Session=Depends(get_db),auth_dict=Depends(auth_middleware)):
  user_id=auth_dict['uid']
  fav_song=db.query(Favorite).filter(Favorite.song_id==song.song_id,Favorite.user_id==user_id).first()
  if fav_song:
    db.delete(fav_song)
    db.commit()
    return{'message':False}
  else:
    new_fav=Favorite(id=str(uuid.uuid4()),song_id =song.song_id,user_id=user_id)
    db.add(new_fav)
    db.commit()
    return{'message':True}

@router.get('/list/favorites')
def list_fav_songs(db:Session=Depends(get_db),auth_dict=Depends(auth_middleware)):
  user_id=auth_dict['uid']
  fav_songs=db.query(Favorite).filter(Favorite.user_id==user_id).options(joinedload(Favorite.song)).all()
  return fav_songs
