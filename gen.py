import datetime

start_date = datetime.date(2024, 8, 5)
end_date = datetime.date(2024, 8, 10)

for i in range((end_date - start_date).days + 1):
    day = start_date + datetime.timedelta(days=i)
    print('{')
    print(f'    "date": "{day}",')
    print('    "content": "Te iubesc enorm de mult! Tu esti fericirea mea!",')
    print('    "image": "https://4kwallpapers.com/images/wallpapers/kitty-couple-kawaii-1920x1080-10102.png"')
    print('},')