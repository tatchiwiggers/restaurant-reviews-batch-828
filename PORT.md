# BEYOND CRUD
Hoje nos iremos um pouco além dos CRUD actions que vocês viram ontem.
porque algumas vezes será interessante criar outras rotas além das 7 
que vocês aprenderam... que são quais pessoal??
index, new, create, show, edit, update e destroy.

## QUICK SETUP -> follow slides
--skip-active-storage
O Active Storage facilita o upload de arquivos para um serviço de armazenamento cloud como
da Amazon, Google e Cloudinary que vocês verão mais pra frente.

--skip-action-mailbox
Action Mailbox roteia emails de entrada para caixas de correio para processamento em rails

# BOOTSTRAP
vamos fazer o mesmo setup de front end que voces fizeram ontem:
vamos adicionar o bootstrap e o simple form ao nosso app

# SIMPLE FORM x FORM_FOR
***SimpleForm é mais leve é também mais customizável*** -> mostrar documentação.

<%= form_for(@restaurant) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
  <%= f.label :address %>
  `<%= f.text_field :address %>`
  <%= f.label :rating %>
  `<%= f.number_field :rating %>`
  <%= f.submit %>
<% end %>

<%= simple_form_for(@restaurant) do |f| %>
  <%= f.input :name %>
  <%= f.input :address %>
  <%= f.input :rating %>
  <%= f.submit %>
<% end %>

# FIRST COMMIT 

## CRUD

## 7 ACTIONS
Vocês viram ontem que os 7 crud actions são gerados por esse simpatico 
metodo chamado resources - e para o modelo restaurant ele vai gerar nossos routes.

## 7 ACTIONS - 2
se fizermos rails routes no terminal depois de chamar o resources no restaurants
teremos esse resultado aqui:

VAMOS COMEÇAR A ESCREVER NOSSA APLICAÇÃO:
hoje nosso app terá 2 modelos: o modelo restaurant e o modelo reviews. 
Vamos começar pelo modelo restaurant - qual a primeira coisa que precisamos
fazer? MODELAR NOSSAS TABELAS NO DB SCHEMA DO KITT.

VAMOS COMEÇAR PELO MODELO RESTAURANT
## CREATES MODELS -> design database
Restaurants(table)
id
name
rating
address

## SCAFFOLD
hoje eu vou gerar nosso modelo de uma forma diferente - vamos usar o gerador scaffold

index, create, new, edit, show, update e destroy.
EU ESTOU USANDO O SCAFFOLD PESSOAL PELO SIMPLES FATO DELE GERAR TODAS AS ROTAS COM SEUS RESPECTIVOS
METODOS PRONTOS, DESSA FORMA NOS PODEMOS COMEÇAR A AULA DE HOJE EXATAMENTE DE ONDE VOCÊS PARARAM ONTEM.

`rails g scaffold Restaurant name address rating:integer`

sempre verifiquem o arquivo de migração depois que vcs gerarem um modelo ou
fizerem qualquer alteração estrutural os modelos de vocês.

vamos ver o que o scaffold gerou:
ele gerou:
## ele gerou o migration file
## ele gerou o model
## ele gerou o route
## ele gerou o controller
## e todos os views

vamos então fazer um rails db:migrate

## check schema - tudo ok...

git add .
git commit -m "scaffold restaurants"

***=======================================================================================***
## METODO CREATE NO CONTROLLER SCAFFOLD:
o metodo create esta um pouco diferente comparado ao que vcs fizeram na aula de ontem. 
Mas não se preocupem vamos passar por aqui trabalhando linha por linha e vou mostrar pra 
vcs o que ha de diferente no nosso metodo create de hoje.
***=======================================================================================***

Nossa base de dados está vazia, então vamos seed nossa base

## ADD FAKER TO GEMFILE
vamos utilizar o faker

## BUNDLE INSTALL

## CREATE A SEED
require 'faker'

puts 'cleaning up database...'
Restaurant.destroy_all
puts 'database is clean!'

puts 'Creating restaurants'
100.times do
  restaurant = Restaurant.create(
    name: Faker::Restaurant.name,
    address: Faker::Address.city,
    rating: rand(1..5),
  )
  puts "restaurant #{restaurant.id} is created."
end

puts 'All Done!'

1. RAILS DB:SEED
2. VAMOS VERIFICAR RAILS C PRA VER SE TUDO DEU CERTO!
3. GIT ADD . GIT COMMIT -M "SEEDED 100 RESTAURANTS"
4. VAMOS DAR UMA OLHADA ENTÃO NO NOSSO LOCALHOST! RAILS S!

# BEYOND CRUD
Já criamos nosso modelo, controller, rotas e nosso seed. Então
vamos agora além do 7 CRUD ACTIONS.

# TOP RESTAURANTS x 2
Digamos que eu queira listar os TOP restaurants do meu app. Nós temos nosso atributo rating no nosso modelo restaurant, e esse rating vai de um a cinco. Eu quero então listar todos os restaurantes que possuam o rating 5.

Vamos então no nosso rails c, e eu quero q vcs me ajudem a criar o query necessário para buscar essa informação.
Bom sabemos que estamos no nosso modelo Restaurant, mas qual metodo do active record vamos utilizar para filtrar esse dado?
(find vai retornar UM, o primeiro registro da base, e o where vai retornar todos que satisfaçam
a minha condição passada no where.)
`Restaurant.where(rating: 5)`

***===========================================================================================***
REST significa Representational State Transfer. Em português, significa Transferência 
de Estado Representacional.

REST: representa o conjunto de princípios de arquitetura da web
RESTful: representa capacidade de determinado sistema aplicar os princípios de REST.
***===========================================================================================***

E COMO QUEREMOS SERÁ A NOSSA ROTA ENTÃO???
# TOP RESTAURANTS x 3 -> SERÁ ASSIM
GET /restaurants/top

## ROUTES
Então no nosso route, vamos introduzir dois novos metodos:
um chamado collection e o outro chamado member. Vamos começar com o collection -
eu sei que vcs ja estão curiosos mas ja ja eu falo ql a diferença entre eles pra vcs.

COLLECTION:
é um método em rails que nos permite criar novas rotas dentro do contexto em que estamos: 
nesse caso, dentro do resources restaurants;

Vamos então abrir um bloco aqui no resources restaurantes e inserir o meu collection.

`resources :restaurants do`
  a rota do metodo que eu inserir aqui nesse contexto vai sempre começar com /restaurants/...
  `collection do`
    o verbo vai ser get porque eu so quero ler, acessar dados
    e o nome da minha rota será top, porque eu quero os top restaurants
    `get :top`
  `end`
`end`

VAMOS FAZER UM RAILS ROUTES E VER O QUE ISSO GEROU PRA GENTE
percebam que temos nossos 7 crud action e uma rota adicional que é nossa rota top restaurants.

e é justamente pq colocamos nosso top dentro do contexto de restaurants que rails sabe que nosso metodo top irá dentro do restaurants controller.

A forma antiga seria fazer:
# get 'top', to: 'restaurants#top', as: :top_restaurants
foi o que vcs fizeram ontem, e funciona perfeitamente tb.
mas não precisamos mais escrever tudo isso. rails existe pra facilitar nossa vida.

## ENTÃO CRIAMOS NOSSA ROTA, QUAL PROXIMO PASSO?

## CRIAR O METODO TOP NO CONTROLLER

def top
  @restaurants = Restaurant.where(rating: 5)
end

e agora o que precisamos fazer é criar nosso view.
top.html.erb

######
<h1>My top Restaurants</h1>

<% @restaurants.each do |restaurant| %>
  <p> <%= restaurant.name %> <%= '⭐' * restaurant.rating %></p>
<% end %>
#####

vamos ver como ficou?

### qual a rota de nosso top restaurants?
## se não lembrar, rails raoutes é seu melhor amigo!
rails routes

`http://localhost:3000/restaurants/top`

RUN SLIDES!!!! stop at CONTROLLER

## slide about the chef
Agora eu quero adicionar uma rota para exibir informações sobre o chef de um restaurante. 
Vamos pensar, nos temos essa informação no meu modelo? Nos temos uma coluna chef?
A primeira coisa que preciso fazer é adicionar a coluna chef_name no meu modelo.
Pra isso precisamos de um novo migration:
sempre seguindo a convençao td bem pessoal? NUNCA, JAMAIS mexer no schema manualmente.

`rails g migration AddChefNameToRestaurants address:string`

rails g migration RemoveChefFNameFromRestaurants price:integer

## ADDING AND REMOVING COLUMNS
vamos olhar nosso arquivo, pra ver se a migração foi adicionada corretamente.

rails db:migrate

## PRECISAMOS ALTERAR NOSSO SEED FILE!!!
`chef_name: ['Roberta Sudbrack', 'Helena Rizzo', 'Alain Ducasse', 'Jamie Oliver'].sample`

rails db:seed

## GIT ADD GIT COMMIT -M "ADDS CHEF_NAME TO RESTAURANTS"

Então agora vamos adicionar nossa rota!!

Ainda dentro do contexto resources restaurant vamos criar nosso metodo member:
resources :restaurants do
    collection do
      # /restaurants/top
      get :top
    end

    member do
      # /restaurants/:id/chef
      get :chef
    end
  end

rails routes:
Vamos então dar uma olhada nas rotas que foram geradas:
Percebam então a diferença entre collection e member. Nosso metodo collection possui 
somente o padrão restaurants/top. nosso metodo member possui restaurants/:id/chef

quando usamos cada um desses metodos?

utilizamos collection quando não precisamos de um id
/restaurants/top
utilizamos member quando precisamos de um id
/restaurants/:id/chef

## RESTAURANTS CONTROLLER
primeiro precisamos encontrar o restaurante!
ja temos um private metodo que faz isso pra gente. então a unica 
coisa que precisamos fazer é adicionar o metodo chef em nosso 
before action.

def chef
  @chef_name = @restaurant.chef_name
end
`chef.html.erb`

## view
<h1><%= @restaurant.name %>'s chef is <%= @chef_name %>.</h1>

## PASSAR SLIDES!!

## NESTED RESOURCES:
Hora de adicionar nosso reviews model, vamos ver como fazer nested resources, ou seja, aninhamento das rotas, que provavelmente será o routing mais complexo q vcs irao fazer.... não haverá nada mais complexo que isso.

***DB schema add review***

Reviews(table)
id
content
restaurant id (references restaurants id)

let's generate our model

`rails g model review content:text restaurant:references`

look at migration
rails db:migrate

AGORA Precisamos agora linkar nosso modelo review com nosso modelo restaurant. 
Como fazer essa conexão? Quem lembra? Dica, aula de associations and validations.

## SLIDE MODELS
`class Restaurant < ApplicationRecord`
  `has_many :reviews, dependent: :destroy`
`end`

Todo mundo sabe o que significa esse dependent destroy?
Significa que quando o objeto é destruído, destroy será chamado em seus objetos associados.

`class Review < ApplicationRecord`
  `belongs_to :restaurant`
`end`

Add `has_many :reviews, dependent: :destroy` no modelo Restaurant.

## vamos fazer então a nossa rota!!
aqui pessoal, nos vamos aninhar nosso reviews dentro do nosso restaurant. 
Alguém saberia me falar porque?
Porque nos precisamos do id do restaurante para deixar um review.
Um review PERTENCE a um restaurante.

`resources :restaurants do`
  `resources :reviews, only: [ :new, :create ]`
`end`

Vamos ver como ficou nosso rails routes

Vamos criar nosso controller

## GENERATE THE CONTROLLER
rails g controller reviews

def new
  @review = Review.new
end

def create
end

vamos começar por aqui, vamos deixar o create vazio por enquanto e depois faremos o resto.
new.html.erb

Vamos usar simple form:
<%= simple_form_for @review do |f| %>
  <%= f.input :content %>
  <!-- adds bootstrap button  -->
  <%= f.submit class: 'btn btn-primary' %>
<% end %>

## ANTES DE RODAR LOCALHOST!!!
O que esse codigo vai gerar pra gente? Ele vai gerar um formulario -> e qual será o action desse formulário?
Alias, melhor, qual o action que queremos que nosso formulario gere?
é isso aqui que nos queremos.
<form action="/restaurants/28/reviews/new" method="post"></form>

Mas não é exatamente o que nosso codigo vai gerar. EPercebam que eu não tenho nenhuma referencia ao meu restaurante. Se eu não tenho referencia ao meu restaurante, de onde tiramos seu id?
Eu preciso encontrar meu restaurante pra gerar esse action que nos falamos agora. Porque do jeito que esta aqui esse simple form so vai gerar isso aqui ó...
<form action="/reviews" method="post"></form>

Se eu for no meu localhost do jeito que está aqui... ele vai quebrar.

## LOAD LOCALHOST

Porque ele ta falando isso? Porque nosso codigo do jeito que está aqui vai gerar um formulário somente com o action '/reviews'. ele vai retornar o erro: método indefinido `reviews_path` 'que é apenas /reviews porém, se formos em nosso rails routes, percebam que nós não temos /reviews em nossas rotas. MAS em nossas rotas temos:
/restaurants/:restaurant_id/reviews

ENTÃO, A PRIMEIRA COISA QUE PRECISAMOS FAZER É ENCONTRAR NOSSO RESTAURANTE DENTRO DO NOSSO REVIEWS CONTROLLER.

Vamos criar um metodo privado:
  private

  def find_restaurant
    #na nossa rota reviews diz :restaurant_id
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

entao:
before_action :find_restaurant

Agora podemos adicionar o restaurante na declaração do nosso simple form. Para que esse
restaurante seja adicionado no action do meu formulário.
Pra fazer isso vamos passar um array contendo [@restaurant, @review]
Agora sim nosso simple form vai gerar o formulario que precisamos.
`PODEMOS INVERTER? NÃO, porque não EXISTE O PATH: /reviews/review_id/restaurants/new` -> temos o contrario.
"/restaurants/restaurant_id/reviews/new"

## VAMOS ENTÃO ESCREVER O CODIGO DO NOSSO METODO CREATE
## no nosso reviews controller

`@review = Review.new(review_params)`

`def review_params`
  `params.require(:review).permit(:content)`
`end`

***strong params***
strong params é um recurso do Rails que impede a atribuição de parâmetros a objetos, a menos que eles tenham sido explicitamente permitidos. Ele possui seu próprio DSL (Domain Specific Language, ou seja, uma sintaxe predefinida que ele entende), e ´é isso que permite indicar quais parâmetros devem ser permitidos
ao criar um novo objeto.
***strong params***

E agora, pessoal, eu posso simplesmente fazer um @review.save? Esta faltando uma informação aqui... o que esta faltando? vamos olhar nosso schema.

Vamos criar um review la no rails console:
Review.create!(content: 'jfdsjfhdfhdsjh')
ele vai me retornar um erro dizendo que preciso de um restaurante. ta faltando o atributo restaurant_id!

FINAL
`@review = Review.new(review_params)`
eu preciso associar o restaurant_id ao meu review.
A gente encontra nosso restaurante com MAS associa - vamos associar.
`@review.restaurant = @restaurant`
`@review.save`
onde seria interessante redirecionarmos nosso usuario? Show page do restaurante certo?
`redirect_to restaurant_path(@restaurant)`

MOSTRAR NO RAILS C QUE RESTAURANT MUST EXIST
Review.create(content: 'testin dddddddddddddddd') -> (Validation failed: Restaurant must exist)

# NEW REVIEW (1)
Bom, vamos adicionar um link para review no nosso restaurant show page.

<%= link_to 'Leave a review', new_restaurant_review_path(@restaurant)  %>

## SLIDE ADDING REVIEWS
## QUEREMOS QUE OS USERS DEIXEM REVIEWS SOBRE UM RESTAURANTE E QUEREMOS 
## MOSTRAR ESSES REVIEWS NO SHOW PAGE DO RESTAURANTE
## We want to let users leave a review about a restaurant, and display them on the restaurant's page.

Vamos ver se esta tudo funcionando:
RESTAURANT SHOW PAGE:
COMO FAÇO PARA ITERAR SOBRE OS REVIEWS?
tenho minha instancia de restaurants (@restaurant) como faço pra listar todos os meus reviews?
porque no meu modelo restaurant tenho que restaurant has many reviews então posso chamar esse metodo.
e que tipo de objeto `@restaurant.reviews` vai me retornar pessoal?
um array!

<% @restaurant.reviews.each do |review| %>
  <p><%= review.content %></p>
  <hr>
<% end %>

# SLIDE -ENRICH RESTAURANT SHOW - COPY PASTE 

OKAY, PERGUNTA... e se eu escrever o. ele vai aceitar?
vamos deixar tb um review em branco.

ACEITOU!! O QUE ESTA FALTANDO AQUI? VALIDATIONS!!
`validates :content, presence: true`
`validates :content, length: { minimum: 3 }`

VAMOS TESTAR ESSAS VALIDATIONS NO RAILS C!!
## remember reload!
vamos no console.
review = Review.new(content: '', restaurant_id: 28)
review = Review.new(content: 'yo', restaurant_id: 28)
review.save
review.valid?
review.errors.messages

PERFEITO, SABEMOS QUE NOSSOS VALIDATIONS ESTÃO FUNCIONANDO!
Vamos testar nossos validations agora no nosso localhost!!!

***REVIEWS CONTROLLER***
  def create
    @review = Review.new(review_params)
    @review.restaurant = @restaurant
    redirect_to restaurant_path(@restaurant)
  end

voltamos para a pagina do restaurante, não recebi nenhum feedback, o review não foi criado eu não faço ideia do que aconteceu.

Como podemos consertar isso? Alguma idea? Com um if else statement DENRTRO do nosso reviews controller. Vejam bem, se sabemos que a forma que temos de validar se um registro é valido ou não é verificar se esse registro foi salvo na base - Podemos usar nosso create para fazer essa verificação.

podemos passar isso aqui na nossa condição. podemos falar:
if @review.save:
  redirect_to restaurant_path(@restaurant)
else
  mostrar o erro no formulario. Isso já é feito pelo simple form
  não precisamos fazer nada no nosso view. A unica coisa que 
  precisamos fazer será nesse if else que vamos adicionar no controller.
end

## REVIEWS CONTROLLER
aqui eu vou dizer,

if @review.save
  redirect_to restaurant_path(@restaurant)
else
  render :new
end

O que é esse render new, como o simple form lida com isso?
O render renderiza esse html, renderiza essa página, e se o @review.save falhar, 
ele renderizará uma nova página -> e o que é esta nova página?
essencialmente meu formulario.

percebamm que meu url diz
http://localhost:3000/restaurants/7/reviews
ESTOU NO MEU CREATE.

e nao http://localhost:3000/restaurants/7/reviews/new

percebam pela URL que nos não estamos mais no new...
permaneceremos na ação de criação, mas exibiremos o modelo da nova página (do nosso new)
a única diferença é que não estou usando a "nova" instância de @review, estou
usando a instância de review que não salvou.
podemos olhar para esta instância em rails c usando new_review.errors.messages
o simple form  lida com isso
render renderiza um html, renderiza uma página
se o SAVE falhar, ele vai renderizar uma nova página pra gente,
E o que é esta nova página? é essencialmente o meu formulário.
esta instância de @review tem validações e o simple form vai nos mostrar os erros
ao renderizer a rota new

if @ review.save
  redirect_to restaurant_path (@restaurant)
caso contrário, permaneceremos no create action, 

o simpe form lida com isso:

change Review.new in reviews show page

redirect to review `redirect_to new_restaurant_review_path(@restaurant)`

## DESTROY
alguem consegue me dizer porque o destroy não está aninhado no resources restaurants?

`resources :reviews, only: [:destroy]`

porque nao precisamos do id do restaurante pra deletar um review. A unica coisa que precisamos é encontrar nosso review e deletá-lo!.

Vamos então pro nosso reviews controller e escrever nosso metodo destroy.

def destroy
  <!-- # se por acaso tivessemos aninhado a rota:  -->
  <!-- @restaurant = Restaurant.find(params[:restaurant_id]) -->
  @review = Review.find(params[:id])
  @review.destroy
  <!-- # restaurant show page -->
  <!-- aqui o `@review.restaurant` eu chamo o restaurante que possui a instancia do review que eu quero apagar-->
  redirect_to restaurant_path(@review.restaurant)
end

Vamos agora adicionar um link delete pra CADA review.
RESTAURANT SHOW PAGE
## ADD LINK INSIDE REVIEW ITERATION!
<% @restaurant.reviews.each do |review| %>
  <p><%= review.content %></p>
  <!-- review_path[DELETE](review)[NEED AN ID] -->
  <!-- O DEFAULT É GET IN THIS CASE WE ARE DELETING SO WE USE METHOD DELETE -->
  <%= link_to 'delete', review_path(review), method: :delete %>
  <hr>
<% end %>

IT WILL BREAK!!!
REMEMBER TO LOOK INTO REVIEWS CONTROLLER AND except: [ destroy ]

# SHALLOW NESTING
eplain

GO TRHU SLIDES TILL THEY ARE DONE!


ANINHAMENTO: SOMENTE NAS ROTAS COLLECTION, NUNCA NAS ROTAS MEMBER!
