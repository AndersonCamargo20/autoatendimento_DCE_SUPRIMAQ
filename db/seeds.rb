# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name:1423


#IMPRESSORAS DCE
Empresa.create(nome: "DCE - UNOCHAPECO", preco_incolor: 0.10, preco_colorida: 0.25)
Impressora.create(modelo: '1423', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '1118', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '1231', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '1212', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '2160', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '2276', tipo: "not_color", preco: 0.10, empresa_id: 1)
Impressora.create(modelo: '1854', tipo: "color",     preco: 0.25, empresa_id: 1)




