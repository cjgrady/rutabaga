{-
Copyright (C) 2017, University of Kansas Center for Research

Lifemapper Project, lifemapper [at] ku [dot] edu,
Biodiversity Institute,
1345 Jayhawk Boulevard, Lawrence, Kansas, 66045, USA

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
-}
module ExampleTree exposing (..)

import DecodeTree exposing (..)
import Json.Decode exposing (decodeString)


tree : Tree
tree =
    case decodeString treeDecoder treeJson of
        Ok tree ->
            tree

        Err e ->
            Debug.crash e


treeJson : String
treeJson =
    """
{"children": [{"children": [{"children": [], "cladeId": 2, "length": 17.761655859533043, "name": "Peltoboykinia_tellimoides", "squid": "253f71616dd216ab69648ba0b1c7acc88992032111ceab53d10a7eb3b4c1acae"}, {"children": [{"children": [{"children": [{"children": [{"children": [{"children": [{"children": [], "cladeId": 9, "length": 1.5966758098637577, "name": "Heuchera_richardsonii", "squid": "38812fa5d76005b182799ffa21780abe6e1d1008504765ce359682e891ecf6d7"}, {"children": [{"children": [], "cladeId": 11, "length": 1.2504527572705442, "name": "Heuchera_caroliniana", "squid": "fa8cbaa3c4d0df586b295964573ecf06a1907f06af6184f1c1719cb785ab8101"}, {"children": [{"children": [{"children": [], "cladeId": 14, "length": 0.6012456035997538, "name": "Heuchera_pubescens", "squid": "56d66eaf3474c32e3ed02c6f2a2fd1a78392fbf3d5c9be2e3e551ecb69232d45"}, {"children": [], "cladeId": 15, "length": 0.6012456035997538, "name": "Heuchera_alba", "squid": "cc8bbb6758a31f6faf88dddb82426e23ab32daa2a12840250204edae8b63616a"}], "cladeId": 13, "length": 0.3076302280262695, "name": ""}, {"children": [{"children": [], "cladeId": 17, "length": 0.6785787840906892, "name": "Heuchera_longiflora", "squid": "04eb74bde4c5e806744ba3de8ae27ef4c44cb858f36e6022f727ac154ba693f9"}, {"children": [], "cladeId": 18, "length": 0.6785787840906892, "name": "Heuchera_americana", "squid": "92fcc804e96d19c2ffdba835ef507ebe84b07f7b8200bd5f3f4baa73567a693e"}], "cladeId": 16, "length": 0.2302970475353341, "name": ""}], "cladeId": 12, "length": 0.3415769256445209, "name": ""}], "cladeId": 10, "length": 0.3462230525932135, "name": ""}], "cladeId": 8, "length": 0.4550374361764966, "name": ""}, {"children": [{"children": [], "cladeId": 20, "length": 1.5798393047386519, "name": "Heuchera_parvifolia", "squid": "266f28def683bf788e174a02789e9bd5bf0f3466a96ae748fd3c0315bd1fa4ec"}, {"children": [{"children": [], "cladeId": 22, "length": 1.0373367036915724, "name": "Heuchera_wootonii", "squid": "4dca0a5d7515a0ff07371d9a61ed6ee3f037bb07381a117a0d406eedefa2e421"}, {"children": [{"children": [], "cladeId": 24, "length": 0.8066789452313685, "name": "Heuchera_inconstans", "squid": "84b8213adfb1e8777bf3df0d39bb808bae2f07f31eff0f886c7535197700d542"}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 28, "length": 0.36801744213621035, "name": "Heuchera_soltisii", "squid": "f9e19dcad2616458da2df7e524cf09108401f0ed1d7df97dc2533b17c05c45a1"}, {"children": [], "cladeId": 29, "length": 0.36801744213621035, "name": "Heuchera_novomexicana", "squid": "3037e536df9ecc0c181f7059df2cf4369ec36a331b943b677a1a9dd1098e0542"}], "cladeId": 27, "length": 0.11321340943251812, "name": ""}, {"children": [], "cladeId": 30, "length": 0.48123085156872847, "name": "Heuchera_glomerulata", "squid": "adaecc271a630623fbf76b0fbc0380ede2f3947eb9497c70d162632ab98e9d98"}], "cladeId": 26, "length": 0.20019638555055153, "name": ""}, {"children": [], "cladeId": 31, "length": 0.68142723711928, "name": "Heuchera_eastwoodiae", "squid": "88093eb8272be2733b652edd444b2bd7307e1e692ae078ad0a1c63c2432e500c"}], "cladeId": 25, "length": 0.12525170811208852, "name": ""}], "cladeId": 23, "length": 0.23065775846020387, "name": ""}], "cladeId": 21, "length": 0.5425026010470795, "name": ""}], "cladeId": 19, "length": 0.47187394130160243, "name": ""}], "cladeId": 7, "length": 1.176778597719423, "name": ""}, {"children": [{"children": [{"children": [], "cladeId": 34, "length": 2.267651082410975, "name": "Heuchera_woodsiaphila", "squid": "b71d73ef9406056c1a523545adfddb40248f085ea6e84f6aca39194a2e597516"}, {"children": [{"children": [{"children": [], "cladeId": 37, "length": 1.112236231006058, "name": "Heuchera_bracteata", "squid": "5c3a6b6e392a815717d66dfbf7c5a4181d338a6917e3413b357e9318e6d233e9"}, {"children": [], "cladeId": 38, "length": 1.112236231006058, "name": "Heuchera_hallii", "squid": "9e43608eba7ebc83467687e4959ccabf3c25661a1709e2b035acffa29d5510fe"}], "cladeId": 36, "length": 0.7999722234109434, "name": ""}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 42, "length": 1.0098596027426083, "name": "Heuchera_mexicana", "squid": "0f2535ee120c326895347fb6421a943c1a7a3f255bbe33e689246a51763994f2"}, {"children": [{"children": [], "cladeId": 44, "length": 0.6727022017247357, "name": "Heuchera_longipetala", "squid": "19b5c2ba6ca08b4027e75aa1d267c923da1d4348aca42c75af45c4f39c1c91cd"}, {"children": [], "cladeId": 45, "length": 0.6727022017247357, "name": "Heuchera_acutifolia", "squid": "d773b8cab5c0bbcc101697ed6f99fa1d0ac5c38b30590dfd52d8a232ccc40f2c"}], "cladeId": 43, "length": 0.3371574010178726, "name": ""}], "cladeId": 41, "length": 0.4527963254466094, "name": ""}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 49, "length": 0.9089853387160751, "name": "Heuchera_hirsutissima", "squid": "36c9b3dd5beae67b937ca31b527c5ae4a80a3ef28fff00903ff1775e4ef0f7c5"}, {"children": [{"children": [{"children": [], "cladeId": 52, "length": 0.4927612870846083, "name": "Heuchera_caespitosa", "squid": "16af2ce027f58cfd878cdbf33b5722fbdea17bc8fe3ddfcd49a358f8229e0629"}, {"children": [], "cladeId": 53, "length": 0.4927612870846083, "name": "Heuchera_abramsii", "squid": "683835815e83a910b4877de7c7f2ef1b2ba671d176d78425dde229c1c21c0b72"}], "cladeId": 51, "length": 0.21751211989885277, "name": ""}, {"children": [{"children": [], "cladeId": 55, "length": 0.5702764208268398, "name": "Heuchera_elegans", "squid": "c070e509bcaf7cc95ab30d761aae50c8d27dc3cf4cde909a21f557d6f3711104"}, {"children": [], "cladeId": 56, "length": 0.5702764208268398, "name": "Heuchera_parishii", "squid": "d4645ba5ab9f1fe267c915f27dcfa8f8a69cc61538889dacc874c0fb604593d2"}], "cladeId": 54, "length": 0.13999698615662126, "name": ""}], "cladeId": 50, "length": 0.19871193173261403, "name": ""}], "cladeId": 48, "length": 0.15224904639183734, "name": ""}, {"children": [], "cladeId": 57, "length": 1.0612343851079125, "name": "Heuchera_brevistaminea", "squid": "a9655bd78c883ac2469e43b582955b8fcf3a4521d7757d11b9a11f32117a2651"}], "cladeId": 47, "length": 0.23571097096003513, "name": ""}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 61, "length": 0.4362375543086614, "name": "Heuchera_rosendahlii", "squid": "14b24a9ee9bc2d482a68ab018015beac1b72c8398446419c5eb86c837a6c0e22"}, {"children": [], "cladeId": 62, "length": 0.4362375543086614, "name": "Heuchera_wellsiae", "squid": "696313d6cf37c5663432fa7b3bf4be09ef6881c0f454a43293162ba469d5c31e"}], "cladeId": 60, "length": 0.4817445066949446, "name": ""}, {"children": [], "cladeId": 63, "length": 0.917982061003606, "name": "Heuchera_sanguinea", "squid": "2dfeb84c36af48dcfac361fe3498e8d07a9a9415cc86d4e77e82f356adfe7d81"}], "cladeId": 59, "length": 0.1809859827895579, "name": ""}, {"children": [], "cladeId": 64, "length": 1.098968043793164, "name": "Heuchera_versicolor", "squid": "e3cfdec7d79241229e23aa5873d1cbe45495f1d3bd42a5719e909023c4dca5ce"}], "cladeId": 58, "length": 0.19797731227478366, "name": ""}], "cladeId": 46, "length": 0.16571057212127016, "name": ""}], "cladeId": 40, "length": 0.21111342075537465, "name": ""}, {"children": [{"children": [], "cladeId": 66, "length": 1.1938080591809417, "name": "Heuchera_pulchella", "squid": "8fd0068c4ab7cf36d9aeeb608e41d05e4fcc8f96a435e01b8450c059fa1e5362"}, {"children": [], "cladeId": 67, "length": 1.1938080591809417, "name": "Heuchera_rubescens", "squid": "ef1ab7833784d81ea21db11e3d0e9b0d9bedb743b3c97a82f5b45d4f979ef97c"}], "cladeId": 65, "length": 0.4799612897636507, "name": ""}], "cladeId": 39, "length": 0.2384391054724091, "name": ""}], "cladeId": 35, "length": 0.3554426279939733, "name": ""}], "cladeId": 33, "length": 0.47200566715888925, "name": ""}, {"children": [{"children": [], "cladeId": 69, "length": 2.3890582670110696, "name": "Heuchera_merriamii", "squid": "6fe3c631902b97cbb48f7943774679dff5bd86d4c54e2c1b92c3c95ef2d1e056"}, {"children": [], "cladeId": 70, "length": 2.3890582670110696, "name": "Heuchera_grossulariifolia", "squid": "87ba42b1bdc43261c63c8c0bde591efad69ba7d3e39b167dc03d9ee8bb77eb84"}], "cladeId": 68, "length": 0.35059848255879444, "name": ""}], "cladeId": 32, "length": 0.4888350941898132, "name": ""}], "cladeId": 6, "length": 0.611602729860282, "name": ""}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 74, "length": 0.4715389203700333, "name": "Heuchera_pilosissima", "squid": "e8d7add6ffc2f3bfc23623d340f2b358643ff961dafc8e73df6c7b8e3ef89b66"}, {"children": [], "cladeId": 75, "length": 0.4715389203700333, "name": "Heuchera_maxima", "squid": "47b697873b763836ae7c3e2f43bac664d050bb88282efe93c94c60c8ab1dbeed"}], "cladeId": 73, "length": 0.5547828033234765, "name": ""}, {"children": [], "cladeId": 76, "length": 1.0263217236935098, "name": "Heuchera_micrantha", "squid": "190e31374a4538d19563aa9c985c90991959c02ecd2bcbe471cddad76a27c399"}], "cladeId": 72, "length": 2.5145741447943273, "name": ""}, {"children": [{"children": [], "cladeId": 78, "length": 3.2241491918893637, "name": "Heuchera_glabra", "squid": "cdfc61168901288d8af6f0d1b548a951b719c89b9c0081183bb62d21c9a7cf10"}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 82, "length": 0.9815068732965422, "name": "Heuchera_villosa", "squid": "e8f27ed1d833be70dd71fe6da8c2ad629db1822919eed00562c3e52535e987ec"}, {"children": [], "cladeId": 83, "length": 0.9815068732965422, "name": "Heuchera_puberula", "squid": "de5aaf6d3c94b6b76b67805a26ece3448e3ed3ff82a2c79fc9de8da577e35c28"}], "cladeId": 81, "length": 0.5071153942854956, "name": ""}, {"children": [{"children": [], "cladeId": 85, "length": 0.9422147820979276, "name": "Heuchera_missouriensis", "squid": "0fcc9b4ca9d87f9ebab1ef56b6ad4f60fd53a54374ae916143f9ad14d0952002"}, {"children": [], "cladeId": 86, "length": 0.9422147820979276, "name": "Heuchera_parviflora", "squid": "fc44011d8599702797e95e89427d7bc3b153d6858ce1e51c188513e92e313fcc"}], "cladeId": 84, "length": 0.5464074854841101, "name": ""}], "cladeId": 80, "length": 1.182633807773751, "name": ""}, {"children": [{"children": [], "cladeId": 88, "length": 1.7450514572618676, "name": "Heuchera_chlorantha", "squid": "277e99c4bcf2a34919620ae5a36a4a3f6d1e037cc079fb4472169bc5173b6a10"}, {"children": [], "cladeId": 89, "length": 1.7450514572618676, "name": "Heuchera_cylindrica", "squid": "31b01c41e68f714829fe61e49a938c52825aa7418d74e272bc767b9bfd13ad33"}], "cladeId": 87, "length": 0.9262046180939212, "name": ""}], "cladeId": 79, "length": 0.5528931165335749, "name": ""}], "cladeId": 77, "length": 0.31674667659847344, "name": ""}], "cladeId": 71, "length": 0.2991987051321221, "name": ""}], "cladeId": 5, "length": 2.2717620145505304, "name": ""}, {"children": [{"children": [{"children": [], "cladeId": 92, "length": 1.8447947010410157, "name": "menziesii", "squid": "d00e7382dbccb6eeb81a2d92746bf446204a4326879443b66f1c02193b25e06c"}, {"children": [], "cladeId": 93, "length": 1.8447947010410157, "name": "diplomenziesii", "squid": "5c865386fbacbde30931ec2b463bbb3b6c5aca084734f0660fcc34928833d66a"}], "cladeId": 91, "length": 3.900212763838672, "name": ""}, {"children": [{"children": [{"children": [], "cladeId": 96, "length": 4.639063367112426, "name": "Tellima_grandiflora", "squid": "cb4e4507016daff4363b0afe8c80503d5cb153e4e1be4a888bf56d1e552e6888"}, {"children": [{"children": [], "cladeId": 98, "length": 4.097702756422063, "name": "Mitella_pentandra", "squid": "eea122035b5aafc233c4aa08a1b34b4c7dd0898c75111801ef4e96809da65d12"}, {"children": [{"children": [{"children": [], "cladeId": 101, "length": 0.6387093039120941, "name": "Mitella_stylosa", "squid": "557ccfded960e4ff692bb0bd82477149be49a7ce0a4b92f1488ba4ae50ef3fa1"}, {"children": [{"children": [], "cladeId": 103, "length": 0.34425176718615447, "name": "Mitella_furusei", "squid": "6655ecf0325609f0c196fe7b9fb6c74be2a5704bb6ffc31e9d1926ef9860e1be"}, {"children": [], "cladeId": 104, "length": 0.34425176718615447, "name": "Mitella_pauciflora", "squid": "1e8d5bfd8d2a4d26cb3750f0974fc1c94f4c74da77a330c17397b5d47a621d9e"}], "cladeId": 102, "length": 0.29445753672593966, "name": ""}], "cladeId": 100, "length": 0.564868364663317, "name": ""}, {"children": [], "cladeId": 105, "length": 1.2035776685754112, "name": "Mitella_japonica", "squid": "006429bb3a05e2ee6245ab9d7e0262bffd1432e9226c362d1d6e575e8aad8c0c"}], "cladeId": 99, "length": 2.8941250878466516, "name": ""}], "cladeId": 97, "length": 0.5413606106903632, "name": ""}], "cladeId": 95, "length": 0.7313617060367275, "name": ""}, {"children": [{"children": [{"children": [{"children": [], "cladeId": 109, "length": 1.5368807510323066, "name": "Mitella_breweri", "squid": "de203e04a3c569d028f8583157c051142e24376caa8ffe770152518ff27af4da"}, {"children": [], "cladeId": 110, "length": 1.5368807510323066, "name": "Mitella_ovalis", "squid": "5fab5c8bd4cdbfd62a0b53418c4342819504b75937561d1634f5cb52cbf733be"}], "cladeId": 108, "length": 2.9798832994681135, "name": ""}, {"children": [], "cladeId": 111, "length": 4.51676405050042, "name": "Bensoniella_oregona", "squid": "e90cdd2736753a418d051642325264f4307047bfadcdc5b154d72e70e182f9a7"}], "cladeId": 107, "length": 0.5038748262552062, "name": ""}, {"children": [{"children": [], "cladeId": 113, "length": 4.444927053456048, "name": "Lithophragma_parviflorum", "squid": "3437951f02c03c705bd14abd7f093684bb22bd0ed9f6ab74cf90827df1361a31"}, {"children": [{"children": [], "cladeId": 115, "length": 2.7621977251235634, "name": "Mitella_nuda", "squid": "eb5f74f60707bbaffde32b62180549482024e0a4b268eae39cf3758549fe9c1f"}, {"children": [], "cladeId": 116, "length": 2.7621977251235634, "name": "Mitella_diphylla", "squid": "6033617be54c97a10e7b2a291f9fa71cea9cdd6b1d93b64af211d77f666370f6"}], "cladeId": 114, "length": 1.682729328332485, "name": ""}], "cladeId": 112, "length": 0.5757118232995779, "name": ""}], "cladeId": 106, "length": 0.34978619639352715, "name": ""}], "cladeId": 94, "length": 0.3745823917305344, "name": ""}], "cladeId": 90, "length": 0.36684912329080177, "name": ""}], "cladeId": 4, "length": 0.3054151405834489, "name": ""}, {"children": [{"children": [], "cladeId": 118, "length": 5.936816161180818, "name": "Tiarella_polyphylla", "squid": "84fb5356b01f7010a952df74a8bf7d6f48ce357ed63697ce0ec7724008c8ed38"}, {"children": [{"children": [{"children": [], "cladeId": 121, "length": 3.2700074248768036, "name": "Elmera_racemosa", "squid": "113a3085ac2c5adaa890da87f6499355984807b50695972f34a45937b2c5b24b"}, {"children": [], "cladeId": 122, "length": 3.2700074248768036, "name": "Mitella_caulescens", "squid": "3f084c13957bf7ee3525b8ac237f769df32e53f0b62b0ae014ad72d2a15f9516"}], "cladeId": 120, "length": 1.2373578645983425, "name": ""}, {"children": [{"children": [], "cladeId": 124, "length": 3.0055458751636337, "name": "Conimitella_williamsii", "squid": "5460b06e839e09674ce4d759175a3ad5b76d266ed4d7a104605ae3918f17e412"}, {"children": [], "cladeId": 125, "length": 3.0055458751636337, "name": "Mitella_stauropetala", "squid": "9426f9bec422b5430f4fcec0444acb195cfa3cc9945896fcd84c3908a8d928f1"}], "cladeId": 123, "length": 1.5018194143115124, "name": ""}], "cladeId": 119, "length": 1.4294508717056722, "name": ""}], "cladeId": 117, "length": 0.48045556757312013, "name": ""}], "cladeId": 3, "length": 11.344384130779105, "name": ""}], "cladeId": 1, "length": 2.2997409923456544, "name": ""}, {"children": [], "cladeId": 126, "length": 20.061396851878698, "name": "Telesonix_jamesii", "squid": "fe728a820f7c1f4b958b45dbda521a4de88a78a53b12410abb34eb5227dcb692"}], "cladeId": 0, "length": 0.0, "name": ""}
"""
