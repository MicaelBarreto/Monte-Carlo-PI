<h1>Aproximação de PI utilizando metodo de Monte Carlo</h1>

# O Projeto
Este projeto tem por objetivo utilizar o metodo de [Monte Carlo](https://pt.wikipedia.org/wiki/M%C3%A9todo_de_Monte_Carlo#Estimativa_para_o_valor_de_%7F'%22%60UNIQ--postMath-0000000B-QINU%60%22'%7F)
para econtrar uma aproximação do valor de PI de forma distribuida com uso de [CUDA](https://pt.wikipedia.org/wiki/CUDA) para fins academicos através de uma GPU NVIDIA, neste caso uma Geforce GTX 1650.
Este projeto segue o modelo SPMD ao qual cada tarefa worker executará o mesmo codigo com carga de trabalho igual e irá gerar dados diferentes randomicos, e retornará os dados para o processo master/pai/host.

## Estrutura do projeto
O projeto encontra-se com os seguintes arquivos:
- **main.cu**: Arquivo cuda base ou host ou master ao qual contem o codigo fonte que servirá como ponto de partida para as execuções.
- **kernels.cu**: Arquivo cuda que contem os codigos a serem executados pelo worker.
- **kernels.cuh**: Biblioteca cuda utilizada para fazer um link entre os codigos de **main.cu** e **kernels.cu**.
- **Makefile**: Arquivo utilizado para facilitar a compilação dos códigos de **main.cu** e **kernels.cu**.

### main.cu
Neste arquivo é feito todo setup do projeto e sua inicialização. Sendo o master, este codigo possui as variaveis de controle,
assim como chama o setup dos workers e os próprios workers, coletando os dados dos mesmos e fazendo o calculo do valor aproxmado de PI.
As variaveis de controle com seus respectivos significados são: 
- **r**: raio da circunferencia
- **n**: numero de threads
- **m**: pontos por thread

### kernels.cu
Neste arquivo possui o setup dos workers e os calculos que estes deveram fazer, ao qual é feita a colocação dos pontos aleatoriamente e separação daqueles que se encontram dentro da circunferencia,
a fim de enviar para o master ou host.

# Requisitos, Configuração e utilização
Como já visto, este projeto utiliza CUDA sendo requisito principal tanto para compilar como para executar os códigos nas GPUs NVIDIA apenas.
Cuda utiliza C/C++ sendo então esta linguagem requisito tambem

## CUDA
Para instalação de CUDA basta seguir a documentação a seguir:

- [Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html).
- [Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html).

## Compilando
A fim de facilitar a compilação foi criado o arquivo Makefile que através do comando *make*, ao qual normalmente vem instalado nos sistema linux mas que tambem tem versões para sistemas windows.

- Utilizando a Makefile basta utilizar o comando:
```
make
```

## Utilização
Para utilizar o projeto basta executar o arquivo **main** gerado na compilação, exemplificado asseguir:
```
$ ./main
Monte Carlo PI Approximation calculated on GPU was 3.14158 and took 10609 ms to calculate
```

# Alguns Resultados Obtidos

- Para r = 32, n = 1024 e m = 100
```
Monte Carlo PI Approximation calculated on GPU was 3.13898 and took 0 ms to calculate
```

- Para r = 128, n = 20 e m = 250000
```
Monte Carlo PI Approximation calculated on GPU was 3.14162 and took 46 ms to calculate
```

- Para r = 128, n = 16384 e m = 100
```
Monte Carlo PI Approximation calculated on GPU was 3.14116 and took 15 ms to calculate
```

- Para r = 256, n = 65536 e m = 20000
```
Monte Carlo PI Approximation calculated on GPU was 3.14158 and took 10781 ms to calculate
```

# Referência
Na confecção deste projeto foi utilizado como base [este video](https://www.youtube.com/watch?v=sWBES_wRpAs) ao qual o codigo fonte encontra-se no [bitbucket](https://bitbucket.org/jsandham/algorithms_in_cuda/src/master/monti_carlo_pi/)