# CEP Fácil

Aplicativo Flutter para consulta de endereços via CEP, utilizando a API pública [ViaCEP](https://viacep.com.br). Os resultados são armazenados localmente para consultas offline.

---

## Funcionalidades

- Consulta de endereço por CEP via API ViaCEP
- Cache local com SQLite para consultas sem internet
- Suporte a tema claro e escuro
- Validação de formato de CEP em tempo real
- Logs de requisição com Talker

---

## Arquitetura

O projeto segue **Clean Architecture** organizada por features:

```
lib/
├── core/
│   ├── di/           # Injeção de dependência (GetIt)
│   ├── error/        # Exceptions e Failures
│   ├── network/      # Cliente Dio configurado
│   ├── router/       # Navegação (GoRouter)
│   ├── theme/        # Tema e ThemeCubit
│   └── utils/        # Validadores
└── features/
    ├── cep/
    │   ├── data/       # Models, DataSources (remote/local), Repository impl
    │   ├── domain/     # Entities, Repository interface, Use Cases
    │   └── presentation/ # Pages, Widgets, CepCubit
    └── splash/
        └── presentation/
```

---

## Stack

| Camada               | Biblioteca                    |
| -------------------- | ----------------------------- |
| Estado               | `flutter_bloc` + Cubit        |
| Injeção de dependência | `get_it`                    |
| HTTP                 | `dio` + `talker_dio_logger`   |
| Armazenamento local  | `sqflite`                     |
| Navegação            | `go_router`                   |
| Logs                 | `talker_flutter`              |
| Testes               | `mocktail` + `bloc_test`      |

---

## Pré-requisitos

- Flutter SDK `^3.12.0`
- Dart SDK `^3.12.0`

---

## Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/cep_facil.git
cd cep_facil

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

---

## Testes

```bash
# Executar todos os testes
flutter test

# Com cobertura
flutter test --coverage
```

Cobertura atual inclui:

- Validador de CEP
- DataSource remoto e local
- Model (serialização/desserialização)
- Repository
- Use Case
- CepCubit e ThemeCubit

---

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
