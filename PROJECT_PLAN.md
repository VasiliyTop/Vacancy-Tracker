# План реализации HH Vacancy Closure Monitor

## Структура проекта

```
hh-vacancy-monitor/
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (dashboard)/
│   │   │   ├── profiles/       # Страница настройки профилей
│   │   │   ├── results/        # Страница результатов
│   │   │   └── scan-runs/      # Журнал сканов
│   │   ├── api/
│   │   │   ├── profiles/
│   │   │   ├── scan/
│   │   │   ├── closed-vacancies/
│   │   │   ├── scan-runs/
│   │   │   └── dicts/
│   │   └── layout.tsx
│   ├── lib/
│   │   ├── hh-client.ts        # HH API клиент
│   │   ├── queue.ts            # BullMQ настройка
│   │   ├── compliance.ts       # Compliance логика
│   │   └── db.ts               # Prisma client
│   ├── workers/
│   │   ├── scan-worker.ts      # Worker для сканирования
│   │   ├── enrichment-worker.ts # Worker для обогащения контактов
│   │   └── cron.ts             # Планировщик задач
│   ├── services/
│   │   ├── vacancy-service.ts  # Логика работы с вакансиями
│   │   ├── contact-parser.ts   # Парсинг email/phone
│   │   └── scan-service.ts     # Логика сканирования
│   ├── components/
│   │   └── ui/                 # shadcn/ui компоненты
│   └── types/
│       └── hh-api.ts           # Типы HH API
├── docker-compose.yml
├── Dockerfile
├── .env.example
└── README.md
```

## Модели данных (Prisma)

1. **SearchProfile** - профили поиска с фильтрами и расписанием
2. **ScanRun** - записи о запусках сканирования
3. **Vacancy** - вакансии с историей статусов
4. **VacancyStatusEvent** - события изменения статуса
5. **Employer** - работодатели
6. **EmployerContact** - контакты работодателей (с source и restricted_usage)

## Очереди (BullMQ)

- `scan:vacancies` - основное сканирование вакансий
- `enrichment:employer` - обогащение контактов работодателя
- `detection:closures` - определение закрытых вакансий

## Алгоритм работы

1. Пользователь создает SearchProfile с фильтрами
2. Запускается scan:vacancies job
3. Worker получает вакансии через HH API (пагинация)
4. Для каждой вакансии: upsert Vacancy, создание VacancyStatusEvent(SEEN)
5. Для работодателей: проверка site_url, отправка в enrichment очередь
6. Enrichment worker парсит сайт компании, извлекает контакты
7. Периодически запускается detection:closures для определения закрытых вакансий
8. UI показывает результаты с фильтрацией и экспортом

## Compliance

- COMPLIANCE_STRICT=true по умолчанию
- HH контакты помечаются restricted_usage=true
- Экспорт CSV исключает restricted контакты
- UI показывает источник контакта
