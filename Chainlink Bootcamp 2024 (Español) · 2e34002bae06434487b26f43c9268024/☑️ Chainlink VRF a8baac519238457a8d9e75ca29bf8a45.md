# ☑️ Chainlink VRF

## Recursos

**Documetación oficial:** 

- [https://dev.chain.link/products/vrf](https://dev.chain.link/products/vrf)
- [https://chain.link/vrf](https://chain.link/automation)

**Servicio:** 

[https://vrf.chain.link/](https://vrf.chain.link/)

## Learning

- Aleatoriedad en Contratos Inteligente (Problema)
    - Las BC deben de ser deterministas
        - todos los nodos deben llegar al mismo resultado=consenso
        - Ejecutar código en el SC que genera aleatoriedad puede provocar conficto
            - cada nodo obtiene un valor aleatorio NO permite llegar a consenso (distintos resultados)
- Chainlink VRF (Verifiable Random Function) (Solución)
    - Servicio de generador de números aleatorios verificables y garantizados
        - tamper-proof random number generator (RNG)
    - permite a los contratos inteligentes acceder a valores aleatorios sin comprometer la seguridad ni la usabilidad
    - Chainlink VRF genera uno o más valores aleatorios y una prueba criptográfica de cómo se determinaron esos valores.
    - La prueba se publica y verifica onchain antes de que cualquier aplicación consumidora pueda utilizarla
- Tipos de servicios (pago) VRF
    - Por suscripción
        - permite financiar solicitudes de múltiples contratos consumidores desde una única suscripción
    - Por financianción directa
        - Los contratos consumidores pagan directamente con LINK cuando solicitan valores aleatorios
- Técnico
    - Contratos/Interfaces Chainlink
        - VRFCoordinatorV2Interface.sol
        - VRFConsumerBaseV2.sol
        - [API reference](https://docs.chain.link/data-feeds/api-reference)
    - Los SC que usan VRF deben tener (entre otras cosas) un método `fulfillRandomWords` que hace de “callback”
        - VRF cuando genere el nº llamará a fulfillRandomWords y disponibilizará el nº aleatorio para el SC
- Arquitectura

## Bootcamp

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=y_iOxra1oLc)

### Challenge

Construimos un NFT dinámico cuya metadata es actualizada Onchain cuando ejecutamos un método del SmartContract que hace uso de VRF. 

Los NFT tiene uno atributo (distance) que acumula “km” según el número aleatorio generado. Este atributo es dinámico. 

Como curiosidad, la metadata no es almacenada en IPFS u offchain. La contiene el propio NFT y el URI que establece es el siguiente “data:application/json;base64,", uri”

Poner en el navegador lo siguiente: data:application/json;base64,eyJuYW1lIjogIkVsZiIsImRlc2NyaXB0aW9uIjogIkNoYWlubGluayBydW5uZXIiLCJpbWFnZSI6ICJodHRwczovL2lwZnMuaW8vaXBmcy9RbVRncW5oRkJNa2ZUOXM4UEhLY2RYQm4xZjViRzNRNWhtQmFSNFU2aG9UdmIxP2ZpbGVuYW1lPUNoYWlubGlua19FbGYucG5nIiwiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAiZGlzdGFuY2UiLCJ2YWx1ZSI6IDB9LHsidHJhaXRfdHlwZSI6ICJyb3VuZCIsInZhbHVlIjogMH1dfQ==

y verás que el navegador muestra

![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20VRF%20a8baac519238457a8d9e75ca29bf8a45/Untitled.png)

`{"name": "Elf","description": "Chainlink runner","image": "https://ipfs.io/ipfs/QmTgqnhFBMkfT9s8PHKcdXBn1f5bG3Q5hmBaR4U6hoTvb1?filename=Chainlink_Elf.png","attributes": [{"trait_type": "distance","value": 0},{"trait_type": "round","value": 0}]}`

### Contratos desarrollados:

- [Runners.sol](../contracts/Runners.sol)
    - [https://testnet.snowtrace.io/address/0xf70e7169e19b1e730f5161d420a785cc2a435867](https://testnet.snowtrace.io/address/0xf70e7169e19b1e730f5161d420a785cc2a435867)
- Suscripción chainlink VRF
    - [https://vrf.chain.link/fuji/1211](https://vrf.chain.link/fuji/1211)
- Visualización en Opensea
    - [https://testnets.opensea.io/collection/runners-467](https://testnets.opensea.io/collection/runners-467)

### Técnico

Los contratos tienen que hacer uso de:

```
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
```

```solidity
// Chainlink VRF
 function run(uint256 tokenId) external returns (uint256 requestId) {

        require (tokenId < tokenIdCounter.current(), "tokenId not exists");

        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        request_runner[requestId] = tokenId;
        return requestId;      
    }

    function fulfillRandomWords(
        uint256 _requestId, /* requestId */
        uint256[] memory _randomWords
    ) internal override {
        require (tokenIdCounter.current() >= 0, "You must mint a NFT");
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        lastRandomWords = _randomWords;

        uint aux = (lastRandomWords[0] % 10 + 1) * 10;
        uint256 tokenId = request_runner[_requestId];
        runners[tokenId].distance += aux;
        runners[tokenId].round ++;

        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', runners[tokenId].name, '",'
                        '"description": "Chainlink runner",',
                        '"image": "', runners[tokenId].image, '",'
                        '"attributes": [',
                            '{"trait_type": "distance",',
                            '"value": ', runners[tokenId].distance.toString(),'}',
                            ',{"trait_type": "round",',
                            '"value": ', runners[tokenId].round.toString(),'}',
                        ']}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        _setTokenURI(tokenId, finalTokenURI);
    }
```

### Futuros retos

- [ ]