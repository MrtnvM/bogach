
## 1. Git Hook

Именуем ветки [номер задачи]_[краткое описание] - 74_install_git_hook
Для упрощения работы с коммитами можно установить Git Hook, который будет в начале сообщения каждого коммита добавять номер текущей ветки.
Чтобы установить Git Hook для текущего проекта выполни команду:
```
./build_scripts/config/install-tools.sh --git-hooks
```

Команда копирует файл `./build_scripts/config/prepare-commit-msg`
в каталог `./.git/hooks/`. 

Git Hooks работают независимо от GUI используемом для работы с Git.
Это может быть CommandLine или SourceTree.
