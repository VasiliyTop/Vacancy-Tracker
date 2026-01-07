# Примеры профилей поиска

## Профиль 1: Москва, Финансовый директор

```json
{
  "name": "Москва - Финансовый директор",
  "text": "Финансовый директор",
  "searchField": "all",
  "areaId": 1,
  "areaName": "Москва",
  "specializationIds": [],
  "onlyWithSalary": false,
  "autoScanEnabled": true
}
```

**API запрос:**
```bash
curl -X POST http://localhost:3000/api/profiles \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Москва - Финансовый директор",
    "text": "Финансовый директор",
    "areaId": 1,
    "areaName": "Москва",
    "autoScanEnabled": true
  }'
```

## Профиль 2: СПб, Финансовый директор, полная занятость

```json
{
  "name": "СПб - Финансовый директор (полная занятость)",
  "text": "Финансовый директор",
  "searchField": "name",
  "areaId": 2,
  "areaName": "Санкт-Петербург",
  "employment": "full",
  "onlyWithSalary": true,
  "autoScanEnabled": true
}
```

**API запрос:**
```bash
curl -X POST http://localhost:3000/api/profiles \
  -H "Content-Type: application/json" \
  -d '{
    "name": "СПб - Финансовый директор (полная занятость)",
    "text": "Финансовый директор",
    "searchField": "name",
    "areaId": 2,
    "areaName": "Санкт-Петербург",
    "employment": "full",
    "onlyWithSalary": true,
    "autoScanEnabled": true
  }'
```

## Профиль 3: Финансовая отрасль

```json
{
  "name": "Финансовая отрасль - Финансовый директор",
  "text": "Финансовый директор",
  "searchField": "all",
  "specializationIds": [7],
  "onlyWithSalary": false,
  "autoScanEnabled": true
}
```

**Примечание:** Специализация ID 7 соответствует "Финансы, банки" в HH API. Получить список всех специализаций можно через `/api/dicts/specializations`.

**API запрос:**
```bash
curl -X POST http://localhost:3000/api/profiles \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Финансовая отрасль - Финансовый директор",
    "text": "Финансовый директор",
    "specializationIds": [7],
    "autoScanEnabled": true
  }'
```

## Профиль 4: Удаленная работа

```json
{
  "name": "Финансовый директор - Удаленно",
  "text": "Финансовый директор",
  "searchField": "all",
  "schedule": "remote",
  "experience": "moreThan6",
  "onlyWithSalary": true,
  "autoScanEnabled": false
}
```

## Параметры профиля

### Обязательные
- `name` (string) - Название профиля
- `text` (string) - Текст поиска (по умолчанию "Финансовый директор")

### Опциональные
- `searchField` - Поле поиска: `"name"`, `"company_name"`, `"description"`, `"all"` (по умолчанию)
- `areaId` (number) - ID региона (1 = Москва, 2 = СПб)
- `areaName` (string) - Название региона (для отображения)
- `specializationIds` (number[]) - Массив ID специализаций
- `employerId` (string) - ID конкретного работодателя
- `employment` - Тип занятости: `"full"`, `"part"`, `"project"`, `"volunteer"`, `"probation"`
- `schedule` - График: `"fullDay"`, `"shift"`, `"flexible"`, `"remote"`, `"flyInFlyOut"`
- `experience` - Опыт: `"noExperience"`, `"between1And3"`, `"between3And6"`, `"moreThan6"`
- `onlyWithSalary` (boolean) - Только с указанием зарплаты
- `autoScanEnabled` (boolean) - Включить автоматическое ежедневное сканирование
- `autoScanCron` (string) - Кастомное расписание в формате cron (если не указано, используется ежедневно в 02:00)

## Получение справочников

### Регионы
```bash
curl http://localhost:3000/api/dicts/areas
```

### Специализации
```bash
curl http://localhost:3000/api/dicts/specializations
```

## Запуск сканирования

После создания профиля можно запустить сканирование:

```bash
curl -X POST http://localhost:3000/api/scan/run \
  -H "Content-Type: application/json" \
  -d '{
    "profileId": "PROFILE_ID",
    "period": 7
  }'
```

Параметры:
- `profileId` (string, обязательный) - ID профиля
- `period` (number, опциональный) - Период в днях (максимум 30)
- `fromDate` (string, опциональный) - Дата начала (ISO format)
- `toDate` (string, опциональный) - Дата окончания (ISO format)
