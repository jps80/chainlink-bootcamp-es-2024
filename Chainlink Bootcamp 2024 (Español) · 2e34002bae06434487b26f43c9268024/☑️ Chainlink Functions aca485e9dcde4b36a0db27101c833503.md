# ☑️ Chainlink Functions

## Recursos

**Documetación oficial:** 

- [https://dev.chain.link/products/functions](https://dev.chain.link/products/functions)
- [https://chain.link/functions](https://chain.link/functions)
- Useful resources
    - [https://usechainlinkfunctions.com/](https://usechainlinkfunctions.com/)
    - [https://functions.chain.link/playground](https://functions.chain.link/playground)

**Servicio:** 

- [https://functions.chain.link/](https://functions.chain.link/)

## Learning

- Problema
    - Un SmartContract no puede invocar o consumir servicios (e.g APIS) externas
    - Limita la capacidad funcional de los SC
- Chainlink Functions (Solución)
    - Ejecución de código externo de manera descentralizada cuyo resultado es criptográficamente verifcable y respaldado por un protocolo de consenso (OCR)
- Funcionamiento:
    1. Tu contrato inteligente envía código fuente en una solicitud a una Decentralized Oracle Network (DON)..
    2. Cada nodo en la DON ejecuta el código en un entorno serverless.
    3. La DON luego agrega todos los valores de retorno independientes de cada ejecución y envía el resultado final de vuelta a tu contrato inteligente.
- Qué podemos hacer con Functions
    - **Conectar a cualquier dato público.**
        - Por ejemplo, puedes conectar tus contratos inteligentes a estadísticas meteorológicas para seguros paramétricos o resultados deportivos en tiempo real para NFTs Dinámicos.
    - **Conectar a datos públicos y transformarlos antes de su consumo**.
        - Podrías calcular el sentimiento de Twitter después de leer datos de la API de Twitter, o derivar precios de activos después de leer datos de precios de [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds).
    - **Conectar a una fuente de datos protegida por contraseña**
        - desde dispositivos IoT como relojes inteligentes hasta sistemas de planificación de recursos empresariales.
    - **Conectar a una base de datos descentralizada externa**
        - como IPFS, para facilitar procesos fuera de la cadena para una dApp o construir un sistema de votación de gobernanza de bajo costo.
    - Conectar a tu aplicación Web2 y construir contratos inteligentes híbridos complejos.
    - **Obtener datos de casi cualquier sistema Web2** como **AWS S3**, **Firebase**, o **Google Cloud Storage**.
- ⚠️ Importante ⚠️
    - Las Funciones de Chainlink son una solución de autoservicio. Debes asegurarte de que las fuentes de datos o APIs especificadas en las solicitudes tengan la calidad suficiente y la disponibilidad adecuada para tu caso de uso.
- Técnico
    - Contratos/Interfaces Chainlink
        - FunctionsClient.sol
        - FunctionsRequest.sol
        - [API reference](https://docs.chain.link/chainlink-functions/api-reference/)
    - 
- Arquitectura
    - 
    
    ![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20Functions%20aca485e9dcde4b36a0db27101c833503/Untitled.png)
    

## Bootcamp

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=RVTWeJn3LNw)

### Challenge

Construimos un SC (TemperatureFunctions.sol) que realiza una petición a la API de [https://wttr.in](https://wttr.in/) 

### Contratos desarrollados:

- [TemperatureFunctions](../contracts/TemperatureFunctions.sol) (day9)
    - 0x338a0d61fa90D64291dB82508ac8e839eda1c964
- [GettingStartedFunctionsConsumer](../contracts/GettingStartedFunctionsConsumer.sol) (day9)
    - 0x3aE5D4309CDb8f6eCf791FdBe2dA671dEE3b5165
- [WeatherFunctions](../contracts/WeatherFunctions.sol) (day10)
    - [https://testnet.snowtrace.io/address/0xd9145CCE52D386f254917e481eB44e9943F39138](https://testnet.snowtrace.io/address/0xd9145CCE52D386f254917e481eB44e9943F39138)
- Suscripción chainlink Functions
    - [https://functions.chain.link/fuji/3283](https://functions.chain.link/fuji/3283)
- 

### Técnico

Los contratos tienen que hacer uso de:

```
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
```

```solidity
// JavaScript source code
    string public source =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3&m`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";

function getTemperature(
        string memory _city
    ) external returns (bytes32 requestId) {

        string[] memory args = new string[](1);
        args[0] = _city;

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source); // Initialize the request with JS code
        if (args.length > 0) req.setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            s_subscriptionId,
            gasLimit,
            donID
        );
        lastCity = _city;

        return s_lastRequestId;
    }

    /**
     * @notice Callback function for fulfilling a request
     * @param requestId The ID of the request to fulfill
     * @param response The HTTP response data
     * @param err Any errors from the Functions request
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }        
        s_lastError = err;

        // Update the contract's state variables with the response and any errors
        s_lastResponse = response;
        lastTemperature = string(response);

        // Emit an event to log the response
        emit Response(requestId, lastTemperature, s_lastResponse, s_lastError);
    }
```

### Adicional

En los repositorios https://github.com/jps80/chainlink-functions y https://github.com/jps80/chainlink-functions-requests puedes encontrar mas ejemplos de las cosas que se pueden hacer con Chainlink functions como consumir APIs donde se requiera el uso de claves/key .