# Virtual Valve MQTT Controller

Aplicação Flutter de IoT industrial demonstrando comunicação e controle em tempo real de uma válvula virtual através do protocolo MQTT. Este projeto foi desenvolvido como forma de aprendizado para entender a comunicação bidirecional, entre aplicações móveis e sensores/atuadores industriais.

## Propósito do Projeto

Este projeto foi criado para explorar e compreender os conceitos fundamentais de comunicação IoT em contextos industriais, especificamente:

- Como aplicações móveis podem se comunicar com dispositivos físicos como válvulas e sensores
- Padrões de comunicação bidirecional em tempo real usando o protocolo MQTT
- Sincronização de estados entre interfaces de hardware e software
- Implementação de padrões de controle industrial em aplicações móveis

A aplicação simula um sistema de controle de válvulas de poço, simulando como sistemas de automação industrial se integram com interfaces de monitoramento e controle móvel.

## Arquitetura

O projeto segue os princípios de Clean Architecture com uma estrutura modular baseada em features, garantindo separação de responsabilidades e manutenibilidade.

### Estrutura de Camadas

```
lib/
├── core/                          # Infraestrutura compartilhada
│   ├── config/                    # Configuração de ambiente
│   ├── constants/                 # Constantes da aplicação
│   ├── errors/                    # Definições de tratamento de erros
│   └── network/                   # Utilitários de rede
├── features/
│   └── valve_control/             # Módulo de feature de controle de válvula
│       ├── data/                  # Camada de dados
│       │   ├── datasource/        # Implementação da fonte de dados MQTT
│       │   ├── models/            # Modelos de dados
│       │   └── repositories/      # Implementações de repositórios
│       ├── domain/                # Camada de lógica de negócio
│       │   ├── entities/          # Entidades de domínio
│       │   ├── repositories/      # Contratos de repositórios
│       │   └── usecases/          # Casos de uso de negócio
│       └── presentation/          # Camada de UI
│           ├── bloc/              # Gerenciamento de estado
│           └── pages/             # Telas da interface
└── injection_container.dart       # Configuração de injeção de dependências
```

### Camadas Arquiteturais

**Camada de Domínio**: Contém a lógica de negócio principal, independente de frameworks externos. Define entidades (ValveEntity), contratos de repositórios e casos de uso (ToggleValveUseCase, StreamValveStatusUseCase).

**Camada de Dados**: Implementa os contratos de repositório definidos na camada de domínio. Gerencia a comunicação MQTT através do ValveMqttDataSource, transformando mensagens MQTT brutas em entidades de domínio.

**Camada de Apresentação**: Gerencia o estado da UI usando o padrão BLoC. O ValveBloc coordena as interações do usuário com os casos de uso de domínio e reflete as mudanças de estado na UI.

## Fluxo de Comunicação

### Tópicos MQTT

A aplicação usa dois tópicos MQTT para comunicação bidirecional:

- `industrial/valve/001/cmd` - Tópico de comando onde o app publica comandos de controle (OPEN/CLOSED)
- `industrial/valve/001/status` - Tópico de status onde o hardware publica seu estado atual

### Fluxo de Dados

1. **Interação do Usuário**: Usuário toca em um botão para abrir ou fechar a válvula
2. **Despacho de Evento**: UI despacha um evento ToggleValveCommand para o ValveBloc
3. **Execução do Caso de Uso**: Bloc chama o ToggleValveUseCase com o estado desejado
4. **Ação do Repositório**: Repositório instrui a fonte de dados a publicar uma mensagem MQTT
5. **Publicação MQTT**: Comando é publicado no tópico `cmd`
6. **Resposta do Hardware**: Hardware simulado recebe o comando e publica status no tópico `status`
7. **Atualização de Stream**: Fonte de dados transmite atualizações de status de volta através do repositório
8. **Atualização de Estado**: Bloc recebe a atualização e emite um novo estado ValveLoaded
9. **Atualização da UI**: BlocBuilder reconstrói a UI para refletir o novo estado da válvula

## Stack Tecnológico

### Dependências Principais

**mqtt_client** (^10.11.9): Biblioteca cliente MQTT para Dart, fornecendo a base para comunicação IoT. Gerencia conexão, publicação/assinatura de mensagens e reconexão automática.

**flutter_bloc** (^9.1.1): Solução de gerenciamento de estado implementando o padrão BLoC (Business Logic Component). Separa a lógica de negócio da UI, tornando o código mais testável e manutenível.

**get_it** (^9.2.1): Service locator para injeção de dependências. Gerencia o ciclo de vida dos objetos e dependências, permitindo baixo acoplamento entre camadas e melhorando a testabilidade.

**fpdart** (^1.2.0): Biblioteca de programação funcional fornecendo o tipo Either para tratamento elegante de erros. Habilita programação orientada a railway onde operações retornam valores de sucesso ou falha.

**equatable** (^2.0.8): Simplifica a comparação de valores em classes Dart. Essencial para comparação de estados do BLoC para determinar quando a UI deve ser reconstruída.

**flutter_dotenv** (^5.2.1): Gerenciamento de variáveis de ambiente. Mantém configurações sensíveis como endereços de broker MQTT e credenciais fora do código fonte.

**typed_data** (^1.4.0): Estruturas de dados tipadas eficientes para lidar com dados binários de payload MQTT.

## Padrões de Design Principais

### Padrão BLoC

A aplicação usa BLoC para gerenciamento de estado, fornecendo um fluxo de dados unidirecional:

- Events representam interações do usuário ou eventos do sistema
- States representam o estado da UI em qualquer momento
- Bloc processa eventos e emite estados correspondentes

### Padrão Repository

Abstrai fontes de dados por trás de interfaces de repositório, permitindo que a camada de domínio permaneça independente de implementações específicas. O ValveRepository define contratos que o ValveRepositoryImpl cumpre usando MQTT.

### Injeção de Dependências

Usa get_it para localização de serviços, registrando dependências em injection_container.dart. Factories fornecem instâncias transientes (BLoC), enquanto lazy singletons garantem instâncias únicas para repositórios e fontes de dados.

### Tratamento Funcional de Erros

Usa Either<Failure, Success> do fpdart em vez de lançar exceções. Operações retornam Left(Failure) para erros e Right(Value) para sucesso, tornando o tratamento de erros explícito e type-safe.

## Configuração de Ambiente

A aplicação usa um arquivo `.env` com as seguintes chaves para configuração:

```env
MQTT_BROKER=
MQTT_PORT=
MQTT_CLIENT_ID=
MQTT_TOPIC_COMMAND=
MQTT_TOPIC_STATUS=
```

A configuração é carregada na inicialização e injetada por toda a aplicação via EnvConfig, garantindo que dados sensíveis não apareçam no código fonte.

## Começando

### Pré-requisitos

- Flutter SDK 3.10.8 ou superior
- Um broker MQTT (usando broker.emqx.io público por padrão)
- Um cliente MQTT para testes (ex: MQTT Explorer, MQTTX)

### Instalação

1. Clone o repositório
2. Copie `.env.example` para `.env` e configure suas configurações MQTT
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute a aplicação:
   ```bash
   flutter run
   ```

### Testando a Comunicação

Para simular respostas do hardware, use um cliente MQTT para:

1. Assinar o tópico de comandos do .env para ver comandos do app
2. Publicar no tópico de status do .env para comunicar com payloads "OPEN" ou "CLOSED" para simular atualizações de status do hardware

A aplicação exibirá o estado da válvula em tempo real conforme as mensagens são recebidas.

## Melhorias Futuras

- Suporte a múltiplas válvulas com assinatura dinâmica de tópicos
- Autenticação e criptografia para conexões MQTT
- Registro de dados históricos e analytics com offline mode
- Integração com dispositivos de hardware reais
