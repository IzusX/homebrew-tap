# IzusX Homebrew tap

[English](README.md) | **Русский**

Пакеты Homebrew, которые поддерживает [IzusX](https://github.com/IzusX).
В этом репозитории могут находиться несколько приложений (`Casks/`) и утилит
командной строки (`Formula/`). Исходники и готовые сборки программ хранятся
в репозиториях соответствующих проектов.

## Arkvello

[Arkvello](https://github.com/IzusX/arkvello) — независимый нативный архиватор
для macOS на базе 7-Zip. Требуется macOS 14 или новее, Apple Silicon или Intel.

```bash
brew install --cask IzusX/tap/arkvello
```

Обновление или удаление:

```bash
brew update
brew upgrade --cask IzusX/tap/arkvello
brew uninstall --cask IzusX/tap/arkvello
```

Приложение имеет подпись ad-hoc, без Developer ID и нотарификации Apple.
macOS может заблокировать запуск. Если доверяете релизу, сначала попробуйте
открыть приложение и следуйте [инструкции Apple «Всё равно открыть»](https://support.apple.com/en-us/102445).
Tap и приложение не отключают Gatekeeper и не снимают атрибут карантина.
Активация расширения Quick Look зависит от политики macOS.

## Сопровождение

Workflow `Update Arkvello` ежедневно проверяет последний опубликованный стабильный
[релиз Arkvello](https://github.com/IzusX/arkvello/releases). Его также можно
запустить вручную во вкладке Actions. Он скачивает релизные файлы, проверяет
их контрольные суммы SHA-256, выполняет аудит сгенерированного cask и сохраняет
изменения `Casks/arkvello.rb` коммитом. Используется встроенный `GITHUB_TOKEN`
этого репозитория; персональный токен или доступ на запись в другой репозиторий
не требуется.

Cask создаются из опубликованных релизов. Новая версия становится доступна
через Homebrew после успешного завершения workflow обновления.

При push и pull request проверяются стиль cask и результаты аудита.
Workflow обновления выполняет те же проверки перед коммитом, поскольку коммиты,
созданные с помощью `GITHUB_TOKEN`, не запускают ещё один workflow по событию push.

Для локального обновления установите `gh`, Homebrew и Python 3, затем выполните:

```bash
bash Scripts/update-arkvello.sh
brew style Casks/arkvello.rb
# В локальной копии, подключённой как tap:
brew audit --cask IzusX/tap/arkvello
```

Файлы упаковки tap распространяются под лицензией MIT; у самих программ
сохраняются собственные лицензии. Arkvello включает компоненты с условиями
LGPL/BSD/unRAR — см. сторонние уведомления проекта.
