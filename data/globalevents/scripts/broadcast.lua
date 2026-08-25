
CONFIG = {


    [1] = {message = "Donate no ot e obtenha Diamond no site pokehand.wix.com/pokehand!", color = 19},
    [2] = {message = "Adquira Diamonds fazendo doaçoes no sitemcom eles é possivel comprar mega box,shiny box,rare candy entre mtas outras coisas! pokehand.wix.com/pokehand OS 3 PRIMEIROS A DONATAR GANHA DOUBLE POINTS!", color = 21},
    [3] = {message = "Quando você conseguir algo importante ou for sair do servidor , use o comando !save para salvar o seu char", color = 21},
	[4] = {message = "Servidor Com Muitas Novidades!", color = 19},
    [5] = {message = "Seja um Doador, e tenha vantagens e tambem ajude o Servidor a crescer,Acesse:pokehand.wix.com/pokehand", color = 21},
    [6] = {message = "Baixem o novo client para não ocorrer bugs, Link:http://www.mediafire.com/download/dy45l11zk2k8361/PokeHand+V3.1.rar", color = 21},
    [7] = {message = "Entre no nosso grupo>https://www.facebook.com/groups/1692988280946247/?fref=ts", color = 21},
    [8] = {message = "Curta nossa page>https://www.facebook.com/PokeHand-928993770454886/?fref=ts", color = 21},
    [9] = {message = "Se inscreva no Canal>https://www.youtube.com/channel/UC9CAaU7b2mXwXHhlNN8F5cA", color = 21},
}

function onThink()
    getRandom = math.random(1, #CONFIG)
    return doBroadcastMessage(CONFIG[getRandom].message, CONFIG[getRandom].color)
end