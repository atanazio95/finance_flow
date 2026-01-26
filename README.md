# Finance Flow 💰

Aplicativo Flutter para gerenciamento financeiro pessoal, desenvolvido seguindo **Clean Architecture** com **BLoC** para gerenciamento de estado.

## 🏗️ Arquitetura

O projeto segue rigorosamente os princípios da **Clean Architecture**, organizando o código em camadas bem definidas:

```
lib/
 ├── core/                    # Código compartilhado entre features
 │   ├── env/                # Configuração de ambientes
 │   ├── error/              # Classes de erro/falha
 │   ├── usecase/            # Classe base para UseCases
 │   ├── utils/              # Utilitários (formatters, etc.)
 │   ├── theme/              # Tema da aplicação
 │   └── di/                 # Injeção de dependências
 │
 ├── features/               # Features do aplicativo
 │   ├── auth/               # Autenticação
 │   │   ├── data/           # Camada de dados (models, datasources, repositories)
 │   │   ├── domain/         # Camada de domínio (entities, repositories, usecases)
 │   │   └── presentation/   # Camada de apresentação (bloc, pages, widgets)
 │   │
 │   ├── dashboard/          # Dashboard com gráficos
 │   ├── transactions/       # CRUD de transações
 │   ├── categories/         # CRUD de categorias
 │   ├── simulation/         # Simulações de gastos fixos
 │   └── export/             # Exportação para PDF
 │
 └── main.dart               # Ponto de entrada da aplicação
```

### Por que Clean Architecture?

1. **Separação de Responsabilidades**: Cada camada tem uma responsabilidade clara
2. **Testabilidade**: Fácil testar cada camada isoladamente
3. **Manutenibilidade**: Mudanças em uma camada não afetam outras
4. **Escalabilidade**: Fácil adicionar novas features seguindo o mesmo padrão
5. **Independência de Frameworks**: Domain não depende do Flutter

### Camadas

#### 1. **Domain** (Camada Interna - Mais Importante)
- **Entities**: Objetos de negócio puros
- **Repositories**: Interfaces (contratos)
- **UseCases**: Regras de negócio

**Por que não depende de Flutter?** Para poder testar e reutilizar em outras plataformas.

#### 2. **Data** (Camada Externa)
- **Models**: Serialização/deserialização
- **DataSources**: Acesso a dados (API, banco, cache)
- **Repository Implementations**: Implementação concreta dos repositórios

#### 3. **Presentation** (Camada Externa)
- **BLoC**: Gerenciamento de estado da UI
- **Pages**: Telas da aplicação
- **Widgets**: Componentes reutilizáveis

**Por que BLoC está aqui?** Porque é específico do Flutter e gerencia estado da UI.

## 🔄 Gerenciamento de Estado - BLoC

Usamos **flutter_bloc** para gerenciamento de estado reativo.

### Estrutura BLoC

Cada BLoC possui:
- **Events**: Ações que podem ocorrer (ex: `LoginEvent`)
- **States**: Estados possíveis (ex: `AuthLoading`, `AuthAuthenticated`)
- **Bloc**: Lógica de transformação de eventos em estados

### Por que BLoC e não outros padrões?

- **Testável**: Fácil testar com `bloc_test`
- **Previsível**: Fluxo unidirecional de dados
- **Desacoplado**: UI não conhece lógica de negócio
- **Rastreável**: Fácil debugar com bloc observer

### Regra de Ouro

> **BLoC não contém lógica de negócio!** Toda lógica de negócio está nos UseCases.

## 🌍 Ambientes (Flavors)

O projeto suporta dois ambientes:

### Homologação (Dev)
- Dados fake/mockados
- Login aceita qualquer email/senha
- Armazenamento local (SharedPreferences)

**Como executar:**
```bash
flutter run --dart-define=ENVIRONMENT=dev
```

### Produção (Prod)
- Estrutura pronta para API real
- Autenticação via OAuth/JWT (preparado, não implementado)

**Como executar:**
```bash
flutter run --dart-define=ENVIRONMENT=prod
```

## 📱 Features

### ✅ Autenticação
- Tela de login
- Login fake para homologação
- BLoC de autenticação
- Estrutura preparada para OAuth/JWT

### ✅ Dashboard
- Gráficos de ganhos, gastos e saldo
- Visualização geral e por categoria
- Transações recentes

### ✅ Transações
- CRUD completo
- Ganhos e gastos
- Associação com categorias
- Espaço reservado para fotos/anexos

### ✅ Categorias
- CRUD de categorias
- Nome e cor personalizada
- Categorias padrão pré-configuradas

### ✅ Simulações
- Simular gastos fixos (cartão, aluguel, luz, água)
- Ver impacto no saldo
- Dados não são persistidos

### ✅ Exportação
- Exportar dados para PDF
- Formato estilo planilha
- Filtro por período

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK (3.8.1 ou superior)
- Dart SDK

### Instalação

1. Clone o repositório
```bash
git clone <url-do-repositorio>
cd finance_flow
```

2. Instale as dependências
```bash
flutter pub get
```

3. Execute o aplicativo
```bash
# Ambiente de homologação (padrão)
flutter run

# Ou especificando ambiente
flutter run --dart-define=ENVIRONMENT=dev
```

## 🧪 Testes

### Estratégia de Testes

Seguimos a **Pirâmide de Testes**:
- **Muitos** testes unitários (UseCases, BLoCs)
- **Alguns** testes de integração
- **Poucos** testes E2E

### Executando Testes

```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Com cobertura
flutter test --coverage
```

Veja mais detalhes em [test/README.md](test/README.md)

## 📦 Dependências Principais

- **flutter_bloc**: Gerenciamento de estado
- **get_it**: Injeção de dependências
- **go_router**: Rotas nomeadas
- **shared_preferences**: Armazenamento local
- **pdf**: Geração de PDFs
- **fl_chart**: Gráficos
- **intl**: Formatação de datas e valores

## 🎯 Decisões Arquiteturais

### Por que UseCases não dependem de Flutter?

UseCases são puros Dart, sem dependências do Flutter. Isso permite:
- Testar sem contexto Flutter
- Reutilizar em outras plataformas (web, desktop)
- Manter o Domain independente

### Por que BLoC está na Presentation?

BLoC é específico do Flutter e gerencia estado da UI. Por isso fica na camada Presentation, não no Domain.

### Por que Models e Entities são separados?

- **Entities**: Objetos de negócio puros, sem serialização
- **Models**: Têm métodos de serialização, podem ter anotações JSON

Isso mantém o Domain limpo e independente.

## 📝 Comentários no Código

Todo o código está extensivamente comentado explicando:
- **Por que** cada classe/arquivo existe
- **Responsabilidades** de cada componente
- **Decisões arquiteturais** tomadas

## 🔮 Próximos Passos

- [ ] Implementar API real para produção
- [ ] Adicionar upload de fotos/anexos
- [ ] Implementar filtros avançados
- [ ] Adicionar gráficos mais detalhados
- [ ] Implementar sincronização em nuvem
- [ ] Adicionar mais testes de integração

## 📄 Licença

Este projeto é um exemplo educacional de Clean Architecture com Flutter.

## 👨‍💻 Autor

Desenvolvido seguindo as melhores práticas de Clean Architecture e BLoC pattern.

---

**Nota**: Este é um projeto educacional demonstrando Clean Architecture com Flutter. Use como referência para seus próprios projetos!
