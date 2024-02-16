# ☑️ Chainlink Data feeds

## Recursos

**Documetación oficial:** 

- [https://docs.chain.link/](https://docs.chain.link/data-feeds)
- [https://chain.link/data-feeds](https://chain.link/data-feeds)

**Servicio:** 

[https://data.chain.link/](https://data.chain.link/)

## Learning

- Fuentes de datos:
    - [Price Feeds](https://docs.chain.link/data-feeds#price-feeds)
        - proporcionan datos agregados de muchas fuentes** de datos por un conjunto descentralizado de operadores de nodos independientes
            - ⚠️ en ocasiones debe confiarse en un única fuente
        - Funcionalidades:
            - Obtener el último precio
            - obtener datos históricos de precios
    - [Feeds de Proof of Reserve](https://docs.chain.link/data-feeds#proof-of-reserve-feeds)
        - proporcionan el estado de las reservas de varios activos (stablecoins, RWA, wrappers):
            - Para activos de fuera de la cadena el origen de datos puede ser:
                - Un tercero (verificado):
                    - da fe de las reservas
                - Depositario
                    - Los datos de las reservas se obtienen directamente del banco o custodio
                - ⚠️ Autocertificado:
                    - Los datos de reserva se leen desde una API que aloja el emisor de token. Los datos autocertificados conllevan un riesgo adicional.a través de la cadena
            - Para activos a través de la cadena el origen de datos:
                - Wallet gestor de direcciones
                    - [IPoRAddressList](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/PoRAddressList.sol) wallet y autodeclara las direcciones que posee
                - Wallet dirección
                    - atestigua qué direcciones posee a través de una API autoalojada.
    - [Price Feeds de Piso NFT](https://docs.chain.link/data-feeds#nft-floor-price-feeds)
        - proporciona una estimación conservadora y aversa al riesgo del precio mínimo de una colección de NFT
        - Aplicable a
            - lending and borrowing, onchain derivatives, dynamic NFTs, gaming guilds, CeFi products, prediction markets
    - [Feeds de Tasa y Volatilidad (Rate and Volatility)](https://docs.chain.link/data-feeds#rate-and-volatility-feeds)
        - proporcionan datos sobre los tipos de interés, las curvas de tipos de interés y la volatilidad de los activos
        - Datos disponibles
            - [Curva de tipos de interés de Bitcoin](https://docs.chain.link/data-feeds/rates-feeds#bitcoin-interest-rate-curve)
                - proporciona un tipo base para ayudar a tomar decisiones de mercado y cuantificar los riesgos de utilizar determinados protocolos y productos basándose en los tipos de interés base actuales y previstos
            - [ETH Staking APR](https://docs.chain.link/data-feeds/rates-feeds#eth-staking-apr)
                - proporciona el dato para la tasa de rendimiento global de staking como validador para asegurar la red Ethereum
            - [Volatilidad realizada](https://docs.chain.link/data-feeds/rates-feeds#realized-volatility)
                - mide el movimiento del precio del activo en un intervalo de tiempo determinado
    - [L2 sequencer uptime feeds](https://docs.chain.link/data-feeds#l2-sequencer-uptime-feeds)
        - proporciona el dato para el último estado conocido del [secuenciador*](https://community.optimism.io/docs/protocol/2-rollup-protocol/) de una L2 en un momento dado.
        - *Secuenciador:
            - componente que ejecuta y acumula las transacciones L2 agrupando varias transacciones en una sola
- [Datos que se pueden conseguir](https://data.chain.link/)
    - Commodities
    - Cryptocurrencies
        - BNB pairs, ETH pairs, USD pairs, others
    - Ethereum gas
    - Foreign exchange
    - Indexes
    - NFT Floor price
    - Proof of reserve
    - StableCoins
- Categorías de data feeds
    - 🟢 Feeds verificados :
        - Feeds que siguen un flujo de trabajo estandarizado data feeds
    - 🟡 Feeds Monitoreados :
        - Feeds en revisión por el equipo de Chainlink Labs para apoyar la estabilidad del ecosistema en general
    - 🟠 Feeds provisionales :
        - Feeds recién liberados en un periodo de prueba provisional de 90 días
    - 🔵 Feeds personalizados :
        - Feeds creados para servir a un caso de uso específico y que pueden no ser adecuados para uso general
    - ⚫ Feeds especializados :
        - Feeds creados con un propósito específico que pueden basarse en contratos mantenidos por entidades externas y que requieren un conocimiento profundo de la metodología de composición antes de su uso.
    - ⭕ En vía de desaparición:
        - Estos feeds están programados para desaparecer.
- Técnico
    - Contratos/Interfaces Chainlink
        - AggregatorV3Interface.sol
        - [Listado Contratos-Protocolos](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1)
        - [API reference](https://docs.chain.link/data-feeds/api-reference)
- Arquitectura
    
    ![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20Data%20feeds%20a8fa1dd1119e48e9a77dd15e7d293663/Untitled.png)
    

## Bootcamp

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=prf1SS1t2hc)

### Challenge

Creamos un ERC20 (TokenERC20.sol) que puede ser adquirido mediante el contrato TokenShop.sol. 

Para realizar la compra, hay que enviar ETH al contrato,  y según la cotización del dolar-USD , que obtenemos gracias a Data Feed, se transfiere una cantidad de Tokens a la razón de —> 1 token = 2.00 usd.

### Contratos desarrollados:

- [TokenShop.sol](../contracts/TokenShop.sol)
    - [https://sepolia.etherscan.io/address/0x2424cfd0d44cbaecfb80d54940bf34dd58216ef2](https://sepolia.etherscan.io/address/0x01cb4d669589f28e54dea901d667ac5930caf492)
- [TokenERC20.sol](../contracts/tokenERC20.sol)
    - [https://sepolia.etherscan.io/address/0x2424cfd0d44cbaecfb80d54940bf34dd58216ef2](https://sepolia.etherscan.io/address/0x2424cfd0d44cbaecfb80d54940bf34dd58216ef2)

### Técnico

Usamos la Interfaz @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol 

Podemos encontrar los Contratos a utilizar para cada red [aquí](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1) 

```solidity
      /**
        * Network: Sepolia
        * Aggregator: ETH/USD
        * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        */
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
```

Mediante el método latesRoundData y el valor retornado “price” recuperamos el precio para poder usarlo en nuestro contrato.

```solidity
/**
    * Returns the latest answer
    */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }
```