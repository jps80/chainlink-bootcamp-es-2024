# ☑️ Chainlink Data Automation

## Recursos

**Documetación oficial:** 

- [https://docs.chain.link/chainlink-automation/](https://docs.chain.link/chainlink-automation/)
- [https://chain.link/automation](https://chain.link/automation)

**Servicio:** 

[https://automation.chain.link/](https://automation.chain.link/)

## Learning

- Automatizar la ejecución de funciones de Contratos Inteligentes mediante la defincición de un “activador” (**Upkeeps**)
    - Upkeep > procesos registrados a ejecutar por la Red Descentralizada de Nodos (trabajos)
- ¿Por qué?
    - Un SmartContract es un agente pasivo que no pueden iniciar por si mismos procesos u acciones
- Tipos activadores
    - **Basados en Tiempo**
        - se ejecuta en función de un horario establecido
    - **Lógica personalizada**
        - se activa mediante la ejecución de un código/lógica concreta (que se encuentra dentro de nuestro SC) y unas condiciones
        - Primero “offchain” > después “onchain”
            - CheckUpKeep nos permite realizar la simulación “offchain”
            - PerfornUpKeep se ejecuta si la simulación es OK/true
    - **De registro**
        - utiliza los datos de registro como activador (eventos)
- Técnico
    - Contratos/Interfaces Chainlink
        - **`[AutomationCompatible.sol](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/automation/AutomationCompatible.sol)`**
            - **`[AutomatizaciónBase.sol](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/automation/AutomationBase.sol)`**
            - **`[AutomatizaciónInterfazCompatible.sol](https://github.com/smartcontractkit/chainlink/blob/master/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol)`**
        - [API reference](https://docs.chain.link/data-feeds/api-reference)
        - 
- Arquitectura
    
    ![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20Data%20Automation%202332ab03ba454fe885bdbf3f85e74569/Untitled.png)
    

## Bootcamp

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=I0J7BiznF_k)

### Challenge

Construimos un NFT dinámico cuya metadata es actualizada Onchain gracias a Chainlink Automation. 

El NFT contiene la imágen de un tigre que será rotada cada cierto tiempo, para ello empleamos un **[Activador lógico personalizado](https://docs.chain.link/chainlink-automation/guides/register-upkeep) (Custom Logic).**

### Contratos desarrollados:

- PhotoAlbum.sol
    - [https://sepolia.etherscan.io/address/0xd9182dede0c8f9cb4d35bf54e9118dd061f9cfe1](https://sepolia.etherscan.io/address/0xd9182dede0c8f9cb4d35bf54e9118dd061f9cfe1)
- Registro de mi automatización
    - [https://automation.chain.link/sepolia/47029791635514978174841946067586681761951290158274503324882070684219217135279](https://automation.chain.link/sepolia/47029791635514978174841946067586681761951290158274503324882070684219217135279)
- Visualización en Opensea
    - [https://testnets.opensea.io/es/collection/photo-album-chainlink-bootcamp-2024-315](https://testnets.opensea.io/es/collection/photo-album-chainlink-bootcamp-2024-315)

### Técnico

La condición que se debe cumplir para rotar la imágen del NFT es la siguiente: 

```solidity
// Chainlink Automation
    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        if ((block.timestamp - lastTimeStamp) > interval ) {
            uint256 tokenId = tokenIdCounter.current() - 1;
            if (photoAlbumIndex(tokenId) < 2) {
                upkeepNeeded = true;
            }
        }
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        if ((block.timestamp - lastTimeStamp) > interval ) {
            uint256 tokenId = tokenIdCounter.current() - 1;
            if (photoAlbumIndex(tokenId) < 2) {
                lastTimeStamp = block.timestamp;            
                rotatePhoto(tokenId);
            }
        }
```

### Futuros retos

- [ ]  Crear un upKeep con una lógica propia
- [ ]  Implementar un ejemplo con [LogTrigger](https://docs.chain.link/chainlink-automation/guides/log-trigger)
- [x]  Implementar un ejemplo basado en Tiempo