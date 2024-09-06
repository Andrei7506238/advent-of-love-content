import datetime

start_date = datetime.date(2024, 11, 1)
end_date = datetime.date(2024, 11, 30)

for i in range((end_date - start_date).days + 1):
    day = start_date + datetime.timedelta(days=i)
    print('{')
    print(f'    "date": "{day}",')
    print('    "content": "",')
    print('    "image": ""')
    print('},')