# Snake для iOS

Простая игра «Змейка» на SwiftUI. Проект собирается автоматически на GitHub
через GitHub Actions в **неподписанный .ipa** (без Apple Developer аккаунта).

## Что внутри

- `Sources/` — код игры (SwiftUI, без сторонних зависимостей)
- `SnakeGame.xcodeproj` — обычный Xcode-проект, уже готов, ничего генерировать
  не нужно (никакого Homebrew/XcodeGen в сборке больше нет — раньше это было
  источником нестабильных ошибок на раннерах GitHub)
- `.github/workflows/build.yml` — workflow, который на macOS-раннере GitHub
  собирает `.app` без подписи и упаковывает в `.ipa`

## Как собрать

1. Создай новый репозиторий на GitHub.
2. Залей туда всё содержимое этой папки (сохраняя структуру, включая
   `.github/workflows/build.yml` и папку `SnakeGame.xcodeproj`).
3. Зайди во вкладку **Actions** репозитория — workflow "Build Unsigned IPA"
   запустится сам при пуше в ветку `main`, либо нажми **Run workflow** вручную.
4. Через 1–3 минуты сборка завершится. Внизу страницы запуска будет
   артефакт **SnakeGame-unsigned-ipa** — скачай его, внутри `SnakeGame.ipa`.

```bash
git init
git add .
git commit -m "Snake iOS game"
git branch -M main
git remote add origin https://github.com/ТВОЙ_ЛОГИН/ТВОЙ_РЕПО.git
git push -u origin main
```

Важно, если заливаешь через веб-интерфейс GitHub (drag & drop), а не
`git push`: убедись, что скрытая папка `.github/workflows/build.yml` и весь
`SnakeGame.xcodeproj/` (включая `project.pbxproj` и
`xcshareddata/xcschemes/SnakeGame.xcscheme`) тоже загрузились — при перетаскивании
папки браузер иногда пропускает файлы, начинающиеся с точки. Надёжнее всего —
через `git push`, как выше.

## Важно про неподписанный .ipa

Файл собран **без подписи** (`CODE_SIGNING_ALLOWED=NO`), поэтому:

- Через AltStore, Sideloadly, TrollStore и подобные инструменты его можно
  подписать твоим Apple ID (бесплатным тоже подойдёт, с ограничением 7 дней
  на бесплатном аккаунте) и установить на телефон.
- Напрямую через `apps.apple.com`/AppStore или просто "по ссылке" установить
  нельзя — iOS требует подпись для установки на реальное устройство.

## Управление в игре

- Свайпы по игровому полю в нужную сторону
- Либо кнопки-стрелки под полем

## Локальная проверка (если есть Mac с Xcode)

```bash
open SnakeGame.xcodeproj
```
