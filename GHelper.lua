script_name('Government helper')
script_author('samartinell')
script_version = 'v. 1.6 Alpha'
script_vers = 1.6

require 'lib.sampfuncs'
require "lib.moonloader" -- подключение библиотеки мунлоадера
local keys = require "vkeys" -- подключение вирт клавиш
local sampev = require 'lib.samp.events' --подключение библиотеки для считывания пакетов из сервера
local font_flag = require('moonloader').font_flag -- шрифты
local memory = require 'memory' -- подключение библиотеки
--IMGUI
local script_author_text = 'samartinell'
local script_name_text = 'Government Helper'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local imgui_help = imgui.ImBool(false)
local interaction_window = imgui.ImBool(false)
local imgui_st_sost = imgui.ImBool(false)
local imgui_lawyer = imgui.ImBool(false)
local imgui_gnews = imgui.ImBool(false)
local imgui_licensor = imgui.ImBool(false)
local imgui_loading = imgui.ImBool(false)
local imgui_mainmenu = imgui.ImBool(false)
local imgui_SB = imgui.ImBool(false)
local imgui_leakmenu = imgui.ImBool(false)
local imgui_obnova = imgui.ImBool(false)
local imgui_obnova_test = imgui.ImBool(false)
local imgui_note = imgui.ImBool(false)
local imgui_bl = imgui.ImBool(false)
local fa = require 'faIcons'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
--INICFG
local inicfg = require 'inicfg'
local directIni = "moonloader/Government Helper/pravoset.ini"
local mainIni = inicfg.load(nil, directIni)
local texture_cat = nil
local texture_cat2 = nil
local texture_background = nil
--local stateIni = inicfg.save(mainIni, directIni)
--local car_handle = storeCarCharIsInNoSave(PLAYER_PED)
local tg = '{CCFF00}[Government]:{CECECE}'
local main_color = '0xCECECE'
local my_font = renderCreateFont('TimesNewRoman', 12, font_flag.BOLD + font_flag.SHADOW) -- основной шрифт
local checkall = false
local lic = 0
local flooder=false

if not doesFileExist(getWorkingDirectory()..'/Government Helper/lblacklist.txt') then -- создание файла, если его нет
    newFile = io.open(getWorkingDirectory().."/Government Helper/lblacklist.txt", "w")
    io.close(newFile)
end
pravoset = false
if not doesFileExist(getWorkingDirectory()..'/Government Helper/pravoset.ini') then
  downloadUrlToFile('https://raw.githubusercontent.com/samartinell/government-helper/master/pravoset.ini',getWorkingDirectory()..'/Government Helper/pravoset.ini')
  pravoset = true
end


local main_rank = mainIni.config.rank
local gnews_text_buffer_1 = imgui.ImBuffer(mainIni.settings.gnews_line_1, 256)
local gnews_text_buffer_2 = imgui.ImBuffer(mainIni.settings.gnews_line_2, 256)
local gnews_text_buffer_3 = imgui.ImBuffer(mainIni.settings.gnews_line_3, 256)
local gnews_text_buffer_4 = imgui.ImBuffer(mainIni.settings.gnews_line_4, 256)
local gnews_text_buffer_5 = imgui.ImBuffer(mainIni.settings.gnews_line_5, 256)
local leakmenu_buffer_id = imgui.ImBuffer('',4)
local note_text_buffer = imgui.ImBuffer(mainIni.note.text, 8192)
local bufferflooder = imgui.ImBuffer('', 124)

--автообновление
local dlstatus = require('moonloader').download_status
update_state = false
local update_url = "https://raw.githubusercontent.com/samartinell/government-helper/master/update.ini" -- ссылка на апдейт
local update_path = getWorkingDirectory() .. "/update.ini" -- ссылка на файл

local script_url = "https://github.com/samartinell/government-helper/blob/master/GHelper.luac?raw=true" -- ссылка на скрипт
local script_path = thisScript().path



function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(10) end
  local ip, port = sampGetCurrentServerAddress()
  downloadUrlToFile(update_url, update_path, function(id, status)
    imgui_obnova_test.v = true
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
          updateIni = inicfg.load(nil, update_path)
          if  updateIni ~= nil then
            if tonumber(updateIni.info.vers) > script_vers then
              sampAddChatMessage(tg.." Есть обновление! Версия: " .. updateIni.info.vers_text, main_color)
              imgui_obnova.v = true
              update_state = true
            else imgui_loading.v = true
          end
        end
          os.remove(update_path)
      end
  end)
  sampRegisterChatCommand('bl', function() imgui_bl.v = not imgui_bl.v end)
  sampRegisterChatCommand('rr', cmd_rr)
  sampRegisterChatCommand('f',fraction_cmd)
  sampRegisterChatCommand('uninv',uninv_cmd)
  sampRegisterChatCommand('inv',inv_cmd)
  sampRegisterChatCommand('invite',invite_cmd)
  sampRegisterChatCommand('ff', cmd_ff)
  sampRegisterChatCommand('hist',hiist_cmd)
  sampRegisterChatCommand('checkf', checkf_cmd)
  sampRegisterChatCommand('qq', cmd_qq)
  sampRegisterChatCommand('fre',fre_cmd)
  sampRegisterChatCommand('r', podrazd_cmd)
  sampRegisterChatCommand('addbl', addbl_cmd)
  sampRegisterChatCommand('lbl', cmd_lbl)
  sampRegisterChatCommand('leakmenu',function() if tonumber(mainIni.config.rank) <5 then sampAddChatMessage(tg..' Продавать налоговою информацию можно только с должности адвокат[5]',main_color) else imgui_leakmenu.v = not imgui_leakmenu.v end end)
  privetstvie = 'true'
  crashaa = false
  sampAddChatMessage(tg..' Подождите, скрипт загружается...', main_color)
  style = 'loading'
  sobes = 100
  imgui_loading.v = true
  local loading = 'true'
  sampRegisterChatCommand('notes', function() imgui_note.v = not imgui_note.v end)
  sampRegisterChatCommand('mm', function() imgui_mainmenu.v = not imgui_mainmenu.v end)
  sampRegisterChatCommand('gov', function() imgui_help.v = not imgui_help.v end)
  sampRegisterChatCommand('gos', function() imgui_gnews.v = not imgui_gnews.v end)
  sampRegisterChatCommand('hh', cmd_hh)
  downloadUrlToFile('https://raw.githubusercontent.com/samartinell/government-helper/master/blblue.txt', getWorkingDirectory()..'/Government Helper/bl.txt')
  while true do
    wait(0)
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- получение айди игрока
    nickname = sampGetPlayerNickname(id) -- получение никнейма игрока
    name, surname = string.match(nickname,'(.+)_(.+)')
    if pravoset then
      downloadUrlToFile('https://raw.githubusercontent.com/samartinell/government-helper/master/pravoset.ini', getWorkingDirectory()..'/Government Helper/pravoset.ini', function(id, status)
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        thisScript():reload()
        end
      end)
      break
    end

    if update_state then
        downloadUrlToFile(script_url, script_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sampAddChatMessage(tg.." Скрипт успешно обновлен!", main_color)
                thisScript():reload()
            end
        end)
        break
    end

    if proverkalic then
      if lic == 2 then
        proverkalic = false
        sampAddChatMessage(tg..' Человек подходит!',main_color)
        lic = 0
      elseif lic <2 then
        proverkalic = false
        sampAddChatMessage(tg..' Человек не подходит',main_color)
        lic = 0
        sobes = 9
      end
    end

if crashaa then
  print('Скрипт был завершен. Для перезагрузки нажмите CTRL+R')
  thisScript():crash()
  repeat
    wait(100000)
  until soadkoksd == true
end

    if privetstvie == 'true' then
      math.randomseed(os.time())
      rand_sob_hey = math.random(0, 3)
      if rand_sob_hey == 0 then
        privet = 'Доброго времени суток'
      elseif rand_sob_hey == 1 then
        privet = 'Здравствуйте'
      elseif rand_sob_hey == 2 then
        privet = 'Приветствую'
      elseif rand_sob_hey == 3 and os.date('%H') >='06' and os.date('%H') < '12' then
        privet = 'Доброе утро'
      elseif rand_sob_hey == 3 and os.date('%H') >='12' and os.date('%H') < '18' then
        privet = 'Добрый день'
      elseif rand_sob_hey == 3 and os.date('%H') >='18' and os.date('%H') < '00' then
        privet = 'Добрый вечер'
      elseif rand_sob_hey == 3 and os.date('%H') >='00' and os.date('%H') < '06' then
        privet = 'Доброй ночи'
      end
    end
    if loading == 'true' and sampIsLocalPlayerSpawned() == true then
      wait(500)
      sampSendChat('/mn') require('samp.events').onShowDialog = function(dialogId, style, dialogTitle, button1, button2, text)
        if dialogId == 487 and sobes ~= 100 then
          lvl = text:match('Проживание в стране .лет.:%s{00e673}(%d+)')
          local zakonoposl = string.match(text, 'Законопослушность:%s+{80aaff}(%d+)')
          if tonumber(lvl) < 4 then
            sampAddChatMessage(tg..' Человек не подходит. Необходимый лвл: 4 | У него: '..lvl,main_color)
            sobes = 7
          elseif tonumber(lvl) >= 4 and tonumber(zakonoposl) < 35 then
            sampAddChatMessage(tg..' Человек не подходит. Необходимо законопослушности: 35 | У него: '..zakonoposl,main_color)
            sobes = 5
          else
            sampAddChatMessage(tg..' С документами всё в порядке. Лет в федерации: '..lvl..' | Законопослушности: '..zakonoposl,main_color)
          end
        end
        if dialogId == 176 then
          roletime = 'true'
        end
        if dialogId == 63 then
          online1 = string.match(dialogTitle, 'онлайн (%d+)')--find
          find = 'true'
          knopka2 = button2
        end
        if dialogId == 27 and loading == 'true' then
          sampSendDialogResponse(27, 1, 0, nil)
        return false
        elseif dialogId == 27 and loading == 'false' and closedial then
          sampCloseCurrentDialogWithButton(0)
          closedial = false
          return false
      end
        if dialogId == 0 and loading == 'true' then
          closedial = true
          number = text:match('Номер телефона:%s+(.+)\nНа счету')
          sex = text:match('Пол:%s+(.......)')
          org = text:match('Организация:%s+(.+)\nПодразделение')
          podrazd = text:match('Подразделение:%s+(.+)\nРабота')
          rankname = text:match('должность:%s+(.+)\nРанг:')
          rank = text:match('Ранг:%s+(.+)\n%s+Проживание')
          if podrazd == 'Мэрия Лос-Сантоса' then
            mainIni.config.podrazd_name = 'LS'
            mainIni.config.podrazd = 'мэрии Лос-Сантос'
        elseif podrazd == 'Мэрия Лас-Вентураса' then
          mainIni.config.podrazd_name = 'LV'
          mainIni.config.podrazd = 'мэрии Лас-Вентурас'
        elseif podrazd == 'мэрия Сан-Фиерро' then
          mainIni.config.podrazd_name = 'SF'
          mainIni.config.podrazd = 'мэрии Сан-Фиерро'
        elseif podrazd == 'Администрация Президента' then
          mainIni.config.podrazd_name = 'АП'
          mainIni.config.podrazd = 'Администрации Президента'
          end
          mainIni.config.phone_number = number
          mainIni.config.sex = sex
          mainIni.config.rank = rank
          mainIni.config.nick = nickname
          mainIni.config.name, mainIni.config.surname = string.match(nickname, '(.+)_(.+)')
          mainIni.config.rankname = rankname
          if mainIni.config.sex == 'Женский' then
            feminism = 'а'
          else
            feminism = ''
          end
          inicfg.save(mainIni, directIni)
          return false
        end
      end
      if ip ~= '54.37.142.74' then
        sampAddChatMessage(tg..' Скрипт предназначен только для Advance RP Blue',main_color) crashaa = true
      elseif org == nil then loading = 'true'
      elseif org ~= 'Правительство' and org == ".+" then
        sampAddChatMessage(tg..' Вы не являетесь сотрудником Правительства, работа скрипта невозможна.',main_color) crashaa = true
      else
        loading = 'false'
        math.randomseed(os.time())
        rand_hey = math.random(1, 2)
        if rand_hey == 1 then
          sampAddChatMessage(tg..' Привет, '..rankname..' '..name..' '..surname..', скрипт успешно загружен!',main_color)
        elseif rand_hey == 2 and os.date('%H') >='06' and os.date('%H') < '12' then
          sampAddChatMessage(tg..' Доброе утро, '..rankname..' '..name..' '..surname..', скрипт успешно загружен!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='12' and os.date('%H') <'18' then
          sampAddChatMessage(tg..' Добрый день, '..rankname..' '..name..' '..surname..', скрипт успешно загружен!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='18' and os.date('%H') < '00' then
          sampAddChatMessage(tg..' Добрый вечер, '..rankname..' '..name..' '..surname..', скрипт успешно загружен!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='00' and os.date('%H') < '06' then

          sampAddChatMessage(tg..' Доброй ночи, '..rankname..' '..name..' '..surname..', скрипт успешно загружен!',main_color)
          end
          wait(1000)
          imgui_loading.v = false
          imgui_obnova.v = false
          imgui_obnova_test.v = false
          style = 'normal'
        sampAddChatMessage(tg..' Для того, чтобы открыть основное меню скрипта, введи /gov.',main_color)
        if sampIsDialogActive() and sampGetCurrentDialogId() == 27 then
          sampCloseCurrentDialogWithButton(0)
        end
        end
    end


    if getCharPlayerIsTargeting() == true and isKeyJustPressed(VK_R) then
      local result, target = getCharPlayerIsTargeting(playerHandle)
      if result then result, targetid = sampGetPlayerIdByCharHandle(target) end
      if sampIsPlayerConnected(targetid) then
      targetnickname = sampGetPlayerNickname(targetid)
      idhh = targetid
      nickhh = sampGetPlayerNickname(idhh)
      interaction_window.v = not interaction_window.v
    end
    end

    --flooder
    if bufferflooder.v ~= '' and flooder and not sampIsChatInputActive() and isKeyJustPressed(VK_K) then
      sampSendChat(bufferflooder.v)
    end

    if sobes == 1 then
      sampSendChat(privet..', я '..mainIni.config.rankname..' '..mainIni.config.name..' '..mainIni.config.surname..', Вы на собедование?')
      sobes = 0
    elseif sobes == 2 then
      math.randomseed(os.time())
      rand_sob_pred = math.random(1, 3)
      if rand_sob_pred == 1 then
        sampSendChat('Хорошо, представьтесь пожалуйста. Как Вас зовут? Сколько Вам лет? Где проживаете?')
      elseif rand_sob_pred == 2 then
        sampSendChat('Представьтесь, пожалуйста. Сколько Вам лет, где проживаете и как зовут?')
      elseif rand_sob_pred == 3 then
        sampSendChat('Вы по адресу! Представьтесь, пожалуйста. Сколько Вам лет, как зовут и где проживаете?')
    end
      sobes = 0
    elseif sobes == 3 then
      math.randomseed(os.time())
      rand_sob_IC = math.random(1, 5)
      if rand_sob_IC == 1 then
        sampSendChat('Что у меня в руке?')
      elseif rand_sob_IC == 2 then
        sampSendChat('Что у меня над головой?')
      elseif rand_sob_IC == 3 then
        sampSendChat('У Вас есть Skype?')
      elseif rand_sob_IC == 4 then
        sampSendChat('У Вас были судимости?')
      elseif rand_sob_IC == 5 then
        sampSendChat('Вы умирали когда-то?')
      end
      sobes = 0
    elseif sobes == 4 then
        sobes = 0
      math.randomseed(os.time())
      rand_sob_dok = math.random(1, 3)
      if rand_sob_dok == 1 then
      sampSendChat('Хорошо, у Вас есть с собой документы? Меня интересуют..')
      wait(500)
      sampSendChat('..пакет лицензий и Ваш паспорт!')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' У игрока должен быть 4 уровень, 35+ законопослушности, базовые права и лицензия на оружие.',main_color)
    elseif rand_sob_dok == 2 then
      sampSendChat('Хм, теперь мне нужно проверить ваши документы!')
      wait(500)
      sampSendChat('А именно паспорт и пакет лицензий')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' У игрока должен быть 4 уровень, 35+ законопослушности, базовые права и лицензия на оружие.',main_color)
    elseif rand_sob_dok == 3 then
      sampSendChat('Самое время проверить ваши документы.')
      wait(500)
      sampSendChat('Мне нужны ваши лицензии и паспорт.')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' У игрока должен быть 4 уровень, 35+ законопослушности, базовые права и лицензия на оружие.',main_color)
    end
  elseif sobes == 5 then
      sampSendChat('/me открыл'..feminism..' КПК и перешёл в базу данных МВД')
      wait(700)
      sampSendChat('/me ввел'..feminism..' информацию по нужному человеку')
      wait(700)
      sampSendChat('/do Процесс..')
      wait(1200)
      sampSendChat('/do Человек имеет проблемы с законом.')
      wait(700)
      sampSendChat('Извините, но Вы нам не подходите. Вы не законопослушны.')
      wait(700)
      sampSendChat('/n для вступления в организацию у Вас не должно быть розыска и 35+ законки.')
      sobes = 100
    elseif sobes == 6  then
      sampSendChat('Поздравляю! Вы прошли собеседование и нам подходите.')
      sobes = 100
      if tonumber(mainIni.config.rank) < 9 then
        sampSetChatInputText('/r Человек в ** прошёл собеседование. Прошу выдать форму и рацию!')
        sampSetChatInputEnabled(true)
      end
    elseif sobes == 7 then
      sampSendChat('Извините, Вы нам не подходите.')
      wait(700)
      sampSendChat('Для трудоустройства в правительство, Вы должны как минимум проживать..')
      wait(700)
      sampSendChat('..4 года в федерации. Приходите позже!')
      sobes = 100
    elseif sobes == 8 then
      sampSendChat('/me внимательно рассмотрел'..feminism..' паспорт человека напротив')
      wait(700)
      sampSendChat('Извините, мы не можем принять Вас так как в вашем паспорте ошибка.')
      wait(700)
      sampSendChat('/n ник должен быть формата Nick_Name и содержать нормальные имена/фамилии')
      sobes = 100
    elseif sobes == 9 then
      sobes = 100
      sampSendChat('Прошу прощения, но Вы нам не подходите.')
      wait(700)
      sampSendChat('У вас нет необходимых лицензий.')
      wait(700)
      sampSendChat('/n У Вас должна быть базовая лицензия на вождение и лицензия на оружие.')
    elseif sobes == 10 and rank < '9' then sampAddChatMessage(tg..' Функция доступна с 9 ранга.',main_color)
      sobes = 100
    elseif sobes == 10 and tonumber(rank) >= 9 then
        sampSendChat('/me открыл'..feminism..' ящик с формами, достал'..feminism..' форму нужного размера')
         wait(500)
         sampSendChat('/me положил'..feminism..' форму на ящик и достал'..feminism..' с нижнего отделения рацию, закрыл'..feminism..' ящик')
         wait(700)
         sampSendChat('/me положил'..feminism..' рацию на пакет с формой и взял'..feminism..' в руки')
         wait(1500)
         sampSendChat('/me передал'..feminism..' форму с рацией человеку напротив')
         sampAddChatMessage(tg..' Введите ID игрока.',main_color)
         sampSetChatInputText('/invite ')
         sampSetChatInputEnabled(true)
      sobes = 100
    elseif sobes == 10 and tonumber(rank) >= 9 then
      sobes = 100
      sampSendChat('/me открыл ящик с формами, достал форму нужного размера')
       wait(500)
       sampSendChat('/me положил'..feminism..' форму на ящик и достал с нижнего отделения рацию, закрыл'..feminism..' ящик')
       wait(700)
       sampSendChat('/me положил'..feminism..' рацию на пакет с формой и взял'..feminism..' в руки')
       wait(1500)
       sampSendChat('/me передал'..feminism..' форму с рацией человеку напротив')
       sampSetChatInputText('/invite '..idhh)
     elseif sobes == 11 then
       sobes = 100
     sampSendChat('Извините, но вы нам не подходите. Вы бредите!')
     wait(1000)
     sampSendChat('/n Почитайте в интернете что такое RP, IC, MG, OOC, после возвращайтесь на собеседование.')
    end
    if roletime == 'true' and mainIni.settings.rptime == true then
      sampSendChat('/me посмотрел'..feminism..' на часы марки Breitling Avi 1953 Limited Edition Platinum')
      wait(300)
      sampSendChat('/do Точное время: '..os.date('%H')..':'..os.date('%M')..':'..os.date('%S'))
        roletime = 'false'
    end
    if find == 'true' and mainIni.settings.rpfind == true and tonumber(online1) <= 20 then
      sampSendChat('/me достал'..feminism..' КПК с кармана')
      wait(200)
      sampSendChat('/me перешел во вкладку «Список сотрудников»')
      wait(200)
      sampSendChat('/do Количество сотрудников в Федерации: '..online1)
      find = 'false'
    elseif find == 'true' and mainIni.settings.rpfind == true and tonumber(online1) > 20 and knopka2 == 'Стр.2 >>' then
      sampSendChat('/me достал'..feminism..' КПК с кармана')
      wait(200)
      sampSendChat('/me перешел во вкладку «Список сотрудников»')
      wait(200)
      sampSendChat('/do Количество сотрудников в Федерации: '..online1)
      find = 'false'
    end

    if freedom == 1 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' Вы отменили подписание документа об УДО.',main_color) freedom = 'start'
    elseif freedom == 1 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
        wait(700)
        sampSendChat('Хорошо, скажите пожалуйста, вы ООП?')
        wait(700)
        sampSendChat('/n Если Вас посадили админы или ФБР, адвокаты Вас не смогут освободить.')
        sampAddChatMessage(tg..' Нажмите клавишу "J", чтобы продолжить или "K", чтобы отменить.',main_color)
        freedom = 2
    elseif freedom == 2 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' Вы отменили подписание документа об УДО.',main_color)
      freedom = 'start'
    elseif freedom == 2 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
      sampSendChat('В таком случае я могу Вас обслужить, сейчас подготовлю все документы.')
      wait(850)
      sampSendChat('/do В руках кейс с необходимой документацией.')
      wait(850)
      sampSendChat('/me открыл'..feminism..' кейс и достал'..feminism..' нужную бумагу, закрыл'..feminism..' кейс и положил'..feminism..' бумагу на него')
      wait(850)
      sampSendChat('/me начал'..feminism..' оформление документов на УДО на имя '..rpnamefree..' '..rpsurnamefree)
      wait(850)
      sampSendChat('/todo Указав пальцем на места для росписи*Мне необходима ваша подпись здесь и здесь.')
      wait(850)
      sampSendChat('/me передал'..feminism..' ручку человеку напротив')
      wait(1000)
      sampSendChat('/n /me расписался(ась)')
      sampAddChatMessage(tg.. ' Нажмите "J" для продолженния или "K" для отмены.',main_color)
      freedom = 3
    elseif freedom == 3 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' Вы отменили подписание документа об УДО.',main_color)
      sampSendChat('/me сложил все документы обратно в кейс') freedom = 'start'
    elseif freedom == 3 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
      sampSendChat('Документы успешно заполнены, сейчас отправлю заявку на УДО.')
      wait(850)
      sampSendChat('/me дал'..feminism..' визитку в руки '..rpnamefree)
      wait(850)
      sampSendChat('/do Информация на визитке: '..mainIni.config.podrazd_name..' | '..mainIni.config.name..' '..mainIni.config.surname..' | '..mainIni.config.rankname)
      wait(850)
      sampSendChat('/free '..freeid..' 9000')
      sampAddChatMessage(tg..' Если человека удалось выпустить, нажмите "H", в противном случае - "R".',main_color)
      freedom = 4
    elseif freedom == 4 and sampIsChatInputActive() == false and isKeyJustPressed(VK_R) then
      sampSendChat('Извините, мне поступила информация, что я не могу Вас обслужить.')
      wait(500)
      sampSendChat('/me сложил все документы обратно в кейс')
      wait(500)
      sampSendChat('/n Вас посадили админы, ФБР, как ООП, у вас недостаточно денег или по другой причине')
      freedom = 'start'
    elseif freedom == 4 and sampIsChatInputActive() == false and isKeyJustPressed(VK_H) then
      sampAddChatMessage(tg..' Вы успешно освободили игрока '..rpnamefree..' '..rpsurnamefree,main_color)
      freedom = 'start'
    end
    if checkf == 'OOP' then
      checkf = nil
      lua_thread.create(function()
      sampSendChat('/do Из МВД поступила информация.')
        wait(1000)
      sampSendChat('/do '..string.match(sampGetPlayerNickname(idf), '(.+)_(.+)')..' Особо Опасный Преступник.')
        wait(800)
        sampSendChat('Извините, по закону я не в праве подписывать документ на УДО для ООП.')
        wait(800)
        sampSendChat('/me спрятал КПК')
      end)
    elseif checkf == 'NeOOP' then
      checkf = nil
      lua_thread.create(function()
        sampSendChat('/do Из МВД поступила информация.')
          wait(1000)
          sampSendChat('/do '..string.match(sampGetPlayerNickname(idf), '(.+)_(.+)')..' не является ООП.')
            wait(700)
            sampSendChat('Всё в порядке, желаете начать подготовку документов на УДО?')
            wait(700)
            sampSendChat('Это будет стоить от 9.000$, если Вы не состоите в государственной организации и 10.000$, если состоите.')
      end)
    end
    if mainIni.settings.quickaction == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_B) then
      if getCharPlayerIsTargeting(playerHandle) == false then sampAddChatMessage(tg..' Наведите на игрока, нажмите ПКМ+Alt+B для активации Quick action.',main_color)
      elseif getCharPlayerIsTargeting(playerHandle) == true and tonumber(rank) == 5 then
        local result_1, target_1 = getCharPlayerIsTargeting(playerHandle)
        if result_1 then result_1, targetid_1 = sampGetPlayerIdByCharHandle(target_1) end
      sampAddChatMessage(tg..' Активирован Quick Release на игрока '..sampGetPlayerNickname(targetid_1),main_color)
      sampSendChat('/free '..targetid_1..' 9000')
      UDOname, UDOsurname = string.match(sampGetPlayerNickname(targetid_1), '(.+)_(.+)')
      lua_thread.create(function()
        wait(500)
      sampSendChat('/do В руках кейс с документацией.')
      wait(800)
      sampSendChat('/me открыл'..feminism..' кейс и достал'..feminism..' необходимые документы на УДО')
      wait(800)
      sampSendChat('/me оформил'..feminism..' УДО на имя '..UDOname..' '..UDOsurname)
      wait(800)
      sampSendChat('/me спрятал'..feminism..' документы обратно в кейс и закрыл его')
      wait(800)
      sampSendChat('/me передал'..feminism..' визитку '..UDOname)
      wait(800)
      sampSendChat('/do Надпись на визитке: '..mainIni.config.name..' '..mainIni.config.surname..' | '..mainIni.config.podrazd_name..' | '..mainIni.config.phone_number)
    end)
  elseif getCharPlayerIsTargeting(playerHandle) == true and tonumber(rank) == 6 then
        local result_1, target_1 = getCharPlayerIsTargeting(playerHandle)
        if result_1 then result_1, targetid_1 = sampGetPlayerIdByCharHandle(target_1) end
        sampAddChatMessage(tg..' Активирован Quick Sell License на игрока '..sampGetPlayerNickname(targetid_1),main_color)
        sampAddChatMessage(tg..' Введите тип лицензии и стоимость её в чате.',main_color)
        lua_thread.create(function()
          local actname, actsurname = string.match(sampGetPlayerNickname(targetid_1), '(.+)_(.+)')
          sampSetChatInputText('/givelic '..targetid_1..' ')
          sampSetChatInputEnabled(true)
          sampSendChat('/do В руках кейс с пустыми бумагами на разные типы лицензий.')
          wait(1000)
          sampSendChat('/me открыл'..feminism..' кейс и достал'..feminism..' необходимые бумаги')
          wait(1000)
          sampSendChat('/me оформил'..feminism..' бумаги на имя '..actname..' '..actsurname)
          wait(1000)
          sampSendChat('/me спрятал'..feminism..' ненужное в кейс')
          wait(1000)
          sampSendChat('/me передал'..feminism..' лицензию человеку напротив')
          wait(1000)
          sampSendChat('Вы не желаете получить скидочный купон на следующую покупку?')
        end)
        end
    end
    if briefing_SB == true then
      lua_thread.create(function()
      briefing_SB = false
      sampSendChat('Так, сейчас мне предстоить провести тебе мини-лекцию...')
      wait(800)
      sampSendChat('По поводу твоих обязанностей на должности СБ.')
      wait(800)
      sampSendChat('Первым делом, ты должен иметь бронежилет и оружие при себе, когда...')
      wait(800)
      sampSendChat('..находишься в мэрии. За пределы её тебе выходить с жилетом и оружием нельзя')
      wait(800)
      sampSendChat('/n /armoff /drop')
      wait(800)
      sampSendChat('Также оружие ты должен применять только в самых редких случаях, когда у тебя...')
      wait(800)
      sampSendChat('..или у других сотрудников мэрии есть угроза жизни. Перед выстрелом сделай предупреждение.')
      wait(800)
      sampSendChat('Для простых беспредельщиков есть дубинка, без предупреждения также нельзя бить.')
      wait(800)
      sampSendChat('Со всем остальным ты можешь ознакомиться лично на портале штата')
      wait(800)
      sampSendChat('/n https://forum.advance.rp/ru - Blue server - организации - правительство - F.A.Q.')
      wait(1000)
      sampSendChat('/c 060')
    end)
    end

    imgui.Process = imgui_help.v or imgui_bl.v or imgui_note.v or interaction_window.v or imgui_st_sost.v or imgui_lawyer.v or imgui_gnews.v or imgui_licensor.v or imgui_loading.v or imgui_mainmenu.v or imgui_SB.v or imgui_leakmenu.v or imgui_obnova.v or imgui_obnova_test.v
    if not imgui_help.v then
      imgui.ShowCursor = true
    end
    if not imgui_bl.v then
      imgui.ShowCursor = true
    end
    if not interaction_window.v then
      imgui.ShowCursor = true
    end
    if not imgui_st_sost.v then
      imgui.ShowCursor = true
    end
    if not imgui_lawyer.v then
      imgui.ShowCursor = true
    end
    if not imgui_gnews.v then
      imgui.ShowCursor = true
    end
    if not imgui_licensor.v then
      imgui.ShowCursor = true
    end
    if not imgui_loading.v then
      imgui.ShowCursor = true
    end
    if not imgui_mainmenu.v then
      imgui.ShowCursor = true
    end
    if not imgui_SB.v then
      imgui.ShowCursor = true
    end
    if not imgui_leakmenu.v then
      imgui.ShowCursor = true
    end
    if not imgui_obnova.v then
      imgui.ShowCursor = true
    end
    if not imgui_obnova_test.v then
      imgui.ShowCursor = true
    end
    if not imgui_note.v then
      imgui.ShowCursor = true
    end
  end
end

function sampev.onServerMessage(color, text)
  msgmm = text
  if text:find('На транспорт: {00CC33}Базовый уровень') and sobes ~= 100 or text:find('На транспорт: {6699CC}Профессиональный уровень') and sobes ~= 100 then
    lic = 0 + 1
  elseif text:find('На оружие:     {00CC33}Есть') and sobes ~= 100 then
    lic = lic + 1
    proverkalic = true
  end
  if text:find('Этот игрок не в тюрьме') and checkall == true then return false
  elseif text:find('Игрока с таким id нет') and checkall == true then return false
  elseif text:find('Этот человек - опасный преступник. Он не может быть освобождён досрочно') and checkall == true then return false
  end
  if checkf == 'true' and text == 'Этот человек - опасный преступник. Он не может быть освобождён досрочно' then
    sampAddChatMessage(tg..' Этот человек ООП, запускаем нужные действия...',main_color)
    checkf = 'OOP'
  elseif checkf == 'true' and text == 'Вы предложили '..sampGetPlayerNickname(idf)..' выйти на свободу за {FF6633}.+' then
      sampAddChatMessage(tg..' Этот человек НЕ ООП и у него достаточно денег, чтобы освободить его из тюрьмы введите /fre '..idf)
      checkf = 'NeOOP'
  end
end




function apply_custom_style()
  if mainIni.settings.darktheme == false then
    texture_cat = imgui.CreateTextureFromFile("moonloader/Government Helper/black_cat.png")
    texture_zoom = imgui.ImVec2(100,50)
    texture_background = imgui.CreateTextureFromFile("moonloader/Government Helper/background.jpg")
    themecolor = '{282828}'
   imgui.SwitchContext()
   local style = imgui.GetStyle()
   local colors = style.Colors
   local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
   local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(7, 7)
    style.WindowRounding = 10.0
    style.FramePadding = ImVec2(5, 5)
    style.ItemSpacing = ImVec2(2, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 5.0
    style.FrameRounding = 5.0


      colors[clr.Text] = ImVec4(0.40, 0.40, 0.40, 1.00)
      colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
      colors[clr.WindowBg] = ImVec4(0.80, 0.80, 0.80, 1.0)
      colors[clr.ChildWindowBg] = ImVec4(1, 1, 1, 0.70)
      colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
      colors[clr.Border] = ImVec4(0.0, 0.0, 0.00, 0.40)
      colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg] = ImVec4(0.70, 0.70, 0.70, 1.00)
      colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
      colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
      colors[clr.TitleBg] = ImVec4(0.50, 0.50, 0.50, 1.0)
      colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
      colors[clr.TitleBgActive] = ImVec4(1, 1, 1, 0.50)
      colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.00)
      colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 0.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 0.00)
      colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 0.00)
      colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.CheckMark] = ImVec4(0.9, 0.1, 0.2, 1.00)
      colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
      colors[clr.Button] = ImVec4(0.95, 0.95, 0.95, 1.00)
      colors[clr.ButtonHovered] = ImVec4(0.90, 0.10, 0.20, 1.00)
      colors[clr.ButtonActive] = ImVec4(1.0, 0.00, 0.00, 1.00)
      colors[clr.Header] = ImVec4(0.95, 0.95, 0.95, 0.55)
      colors[clr.HeaderHovered] = ImVec4(0.90, 0.10, 0.10, 1.00)
      colors[clr.HeaderActive] = ImVec4(1.0, 0.00, 0.00, 1.00)
      colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
      colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
      colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.CloseButton] = ImVec4(0.40, 0.40, 0.40, 1.0)
      colors[clr.CloseButtonHovered] = ImVec4(0.50, 0.20, 0.20, 0.9)
      colors[clr.CloseButtonActive] = ImVec4(0.8, 0.0, 0.0, 1.00)
      colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
      colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
      colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
    end
    if mainIni.settings.darktheme == true then
      texture_cat = imgui.CreateTextureFromFile("moonloader/Government Helper/white cat.png")
      texture_zoom = imgui.ImVec2(50,50)
      themecolor = '{CECECE}'
      imgui.SwitchContext()
      local style = imgui.GetStyle()
      local colors = style.Colors
      local clr = imgui.Col
     local ImVec4 = imgui.ImVec4
      local ImVec2 = imgui.ImVec2

      style.WindowPadding = ImVec2(7, 7)
      style.WindowRounding = 10.0
      style.FramePadding = ImVec2(5, 5)
      style.ItemSpacing = ImVec2(2, 8)
      style.ItemInnerSpacing = ImVec2(8, 6)
      style.IndentSpacing = 25.0
      style.ScrollbarSize = 15.0
      style.ScrollbarRounding = 15.0
      style.GrabMinSize = 15.0
      style.GrabRounding = 7.0
      style.ChildWindowRounding = 5.0
      style.FrameRounding = 5.0


      colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
      colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
      colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
      colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
      colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
      colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
      colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
      colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
      colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
      colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
      colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
      colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
      colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
      colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
      colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
      colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
      colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
      colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
      colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
      colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
      colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
      colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
      colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
      colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
      colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
      colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
    end
end
apply_custom_style()



function imgui.TextColoredRGB(text, render_text)
    local max_float = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end

            local length = imgui.CalcTextSize(w)
            if render_text == 2 then
                imgui.NewLine()
                imgui.SameLine(max_float / 2 - ( length.x / 2 ))
            elseif render_text == 3 then
                imgui.NewLine()
                imgui.SameLine(max_float - length.x - 5 )
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end


        end
    end

    render_text(text)
end


function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/Government Helper/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

--if texture_background ~= nil then imgui.Image(texture_background, imgui.ImVec2(550, 300)) end
--imgui.Selectable(u8'name', state)
local menu_selected = 10
local setting_1 = mainIni.settings.rpfind
local setting_2 = mainIni.settings.rptime
local setting_3 = mainIni.settings.rpradio
local setting_4 = mainIni.settings.quickaction
local setting_5 = mainIni.settings.darktheme
function imgui.OnDrawFrame()
  if imgui_help.v then
    imgui.ShowCursor = true
    local btnSize = imgui.ImVec2(133, 0)
    local fortext = imgui.ImVec2(180, 0)
    local cmd_a = imgui.ImVec2(385,250)
    local buttonSize = imgui.ImVec2(357, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(550, 300), imgui.Cond.FirstUseEver)
    imgui.Begin(u8' '..script_name_text, imgui_help, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.BeginChild('Help menu', imgui.ImVec2(145, 250), true)
    if imgui.Button(fa.ICON_INFO..u8' Информация',btnSize) then menu_selected = 10 end
    if imgui.Button(fa.ICON_QUESTION_CIRCLE_O..u8' Помощь', btnSize) then menu_selected = 1 end
    if imgui.Button(fa.ICON_USER_PLUS..u8' Собеседование',btnSize) then menu_selected = 3 end
    if imgui.Button(fa.ICON_BULLHORN..u8' Гос новости',btnSize) then
      imgui_help.v = false
      imgui_gnews.v = true
    end
    if imgui.Button(fa.ICON_WINDOW_MAXIMIZE..u8' Главное меню', btnSize) then
      imgui_help.v = false
      imgui_mainmenu.v = true
    end
      if imgui.Button(fa.ICON_COG..u8' Настройки', btnSize) then menu_selected = 2 end
      if texture_cat ~= nil then imgui.Image(texture_cat, texture_zoom) end
    imgui.EndChild()
    imgui.SameLine()
    if menu_selected == 10 then --ИНФОРМАЦИЯ--
      imgui.BeginChild('textmmenu', cmd_a, true)
      imgui.TextColoredRGB(themecolor..u8'Government Helper by samartinell\n '..themecolor..fa.ICON_PAW..u8' Привет, {FFA500}'..mainIni.config.name..' '..mainIni.config.surname..u8''..themecolor..u8', вот какие нововведения уже\n '..themecolor..u8' доступны в новой версии:\n\n-'..themecolor..u8' Добавлено основное меню для всех рангов с уникальными\n '..themecolor..u8'фишками\n-'..themecolor..u8' Обновились ImGui интерфейсы')
      imgui.TextColoredRGB('-'..themecolor..u8' Добавлено больше вариативности и рандома в твоих ответах\n-'..themecolor..u8' Добавлена гос. волна для лидеров(beta)\n-'..themecolor..u8' Исправлены баги\n\t\t\t\t\t\t\t\t\t\t\t\t\tВерсия скрипта: '..script_version)
      imgui.EndChild()
    elseif menu_selected == 1 then
      imgui.BeginChild('helpmenu', cmd_a,true)
      imgui.TextColoredRGB(u8'\t\t\t\t\t\t\t\tКоманды скрипта:\n\n/gov '..themecolor..u8' - Основное меню.\n/qq '..themecolor..u8'- поприветствоваться\n/rr'..themecolor..u8' - OOC сообщение в рацию /r\n/ff'..themecolor..u8' - OOC сообщение в рацию /f\n/fre ID '..themecolor..u8' - освободить с отыгровкой человека(для адвокатов)\n/hh ID (или ПКМ+R) '..themecolor..u8' - взаимодействие с игроком.\n/mm'..themecolor..u8' - Главное меню(для разных должностей)\n/gos'..themecolor..u8' - Гос новости ')
      imgui.TextColoredRGB(u8'/leakmenu'..themecolor..u8' - меню продажи информации\n\n\n'..themecolor..u8'Связь с разработчиком:\n'..fa.ICON_ENVELOPE..u8' samartinell@gmail.com')
      imgui.SameLine()
      if imgui.Button('  '..fa.ICON_EXTERNAL_LINK,imgui.ImVec2(30,0)) then os.execute("start https://mail.google.com/") end
      imgui.TextColoredRGB(fa.ICON_PAPER_PLANE..' https://t.me/samartinell')
      imgui.SameLine()
      if imgui.Button(' '..fa.ICON_EXTERNAL_LINK) then os.execute("start https://t.me/samartinell") end
      imgui.TextColoredRGB(fa.ICON_VK..u8' https://vk.com/samartinell')
      imgui.SameLine()
      if imgui.Button(''..fa.ICON_EXTERNAL_LINK) then os.execute("start https://vk.com/samartinell") end
      imgui.EndChild()
    elseif menu_selected == 2 then
      imgui.BeginChild('settingsmenu', cmd_a,true)
      if setting_1 == true and imgui.RadioButton(u8"RP /find(вкл)", setting_1) then setting_1 = false mainIni.settings.rpfind = setting_1 inicfg.save(mainIni, directIni) elseif setting_1 == false and imgui.RadioButton(u8"RP /find(выкл)", setting_1) then setting_1 = true mainIni.settings.rpfind = setting_1 inicfg.save(mainIni, directIni)
      elseif setting_2 == true and imgui.RadioButton(u8"RP /c 60(вкл)", setting_2) then setting_2 = false mainIni.settings.rptime = setting_2 inicfg.save(mainIni, directIni) elseif setting_2 == false and imgui.RadioButton(u8"RP /c 60(выкл)", setting_2) then setting_2 = true mainIni.settings.rptime = setting_2 inicfg.save(mainIni, directIni)
      elseif setting_3 == true and imgui.RadioButton(u8"RP рация(вкл)", setting_3) then setting_3 = false mainIni.settings.rpradio = setting_3 inicfg.save(mainIni, directIni) elseif setting_3 == false and imgui.RadioButton(u8"RP рация(выкл)", setting_3) then setting_3 = true mainIni.settings.rpradio = setting_3 inicfg.save(mainIni, directIni)
      elseif setting_4 == true and imgui.RadioButton(u8"Quick action(вкл)", setting_4) then setting_4 = false mainIni.settings.quickaction = setting_4 inicfg.save(mainIni, directIni) elseif setting_4 == false and imgui.RadioButton(u8"Quick action(выкл)", setting_4) then setting_4 = true mainIni.settings.quickaction = setting_4 inicfg.save(mainIni, directIni)
      elseif setting_5 == true and imgui.RadioButton(u8"Тёмная тема(вкл)", setting_5) then setting_5 = false mainIni.settings.darktheme = setting_5 inicfg.save(mainIni, directIni) sampAddChatMessage(tg..' Вы вернулись на светлую сторону!',main_color) sampAddChatMessage(tg..' Выбранный стиль применится после перезагрузки скрипта.',main_color) elseif setting_5 == false and imgui.RadioButton(u8"Тёмная тема(выкл)", setting_5) then setting_5 = true mainIni.settings.darktheme = setting_5 inicfg.save(mainIni, directIni) sampAddChatMessage(tg..' Вы перешли на тёмную сторону.',main_color)  sampAddChatMessage(tg..' Выбранный стиль применится после перезагрузки скрипта.',main_color)
      end
      imgui.Text('\n\n\n')
      if imgui.Button(fa.ICON_REFRESH..u8'Перезагрузить скрипт', imgui.ImVec2(191, 0)) then  lua_thread.create(function() imgui_help.v = false wait(100) thisScript():reload() end) end
      imgui.SameLine()
      if imgui.Button(fa.ICON_POWER_OFF..u8'Выключить скрипт',imgui.ImVec2(191, 0)) then lua_thread.create(function() imgui_help.v = false wait(100) crashaa = true end) end
      imgui.EndChild()
    elseif menu_selected == 3 then
      --sobes
      imgui.BeginChild('commandmenu', cmd_a,true)
      if imgui.Button(u8'\tПриветствие', buttonSize) then sobes = 1 end
      if imgui.Button(u8'Попросить представиться', buttonSize) then sobes = 2 end
      if imgui.Button(u8'IC вопрос',buttonSize) then sobes = 3 end
      if imgui.Button(u8'Документы',buttonSize) then sobes = 4 end
      if imgui.Button(u8'Подходит',buttonSize) then sobes = 6 end
      if imgui.Button(u8'Провести инструктаж',buttonSize) then briefing_SB = true end
      if imgui.Button(u8'Принять в организацию',buttonSize)  then sobes = 10 end
      if imgui.CollapsingHeader(u8'Не подходит',buttonSize) then --sobes = 5 end
      if imgui.Button(u8'Бредит',buttonSize) then sobes = 11 end
      if imgui.Button(u8'Проблемы с законом',buttonSize) then sobes = 5 end
      if imgui.Button(u8'Мало лет в штате',buttonSize) then sobes = 7 end
      if imgui.Button(u8'Ошибка в имени',buttonSize) then sobes = 8 end
      if imgui.Button(u8'Нет лицензий',buttonSize) then sobes = 9 end
      end
      imgui.EndChild()
    end
    imgui.End()
  end
  if interaction_window.v then
    local btnsizeint = imgui.ImVec2(350,0)
    imgui.ShowCursor = true
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.Always)
    imgui.Begin(u8'Взаимодействие с игроком: '..nickhh..'['..idhh..']',interaction_window,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local button_1 = imgui.Button(u8'Взаимодействие для ст. состава.',btnsizeint)
    local button_2 = imgui.Button(u8'Взаимодействие с заключённым(только для адвокатов)',btnsizeint)
    local button_3 = imgui.Button(u8'Взаимодействие для лицензёров',btnsizeint)
    local button_4 = imgui.Button(u8'Взаимодействие для СБ',btnsizeint)
    if button_4 then interaction_window.v = false imgui_SB.v = true end
    if button_1 and tonumber(rank) >= 5 then -- СДЕЛАТЬ ДЛЯ 8+ РАНГОВ
      interaction_window.v = false
      imgui_st_sost.v = true
    elseif button_1 and tonumber(rank) <5 then --СДЕЛАТЬ ДЛЯ 8+ РАНГОВ
      sampAddChatMessage(tg..' Раздел предназначен для 8+ ранга.', main_color)
    end
    if button_2 and tonumber(rank) == 5 then
      interaction_window.v = false
      imgui_lawyer.v = true
    elseif button_2 and tonumber(rank) ~= 5 then
      sampAddChatMessage(tg..' Функция доступна только адвокатам.',main_color)
    end
  if button_3 and tonumber(rank) >=6 and tonumber(rank) <= 7 then -- ПОДСТАВИТЬ 6 И 7 РАНГ
    interaction_window.v = false
    imgui_licensor.v = true
  elseif button_3 and tonumber(rank) < 6 or button_3 and tonumber(rank) >7 then--ПОДСТАВИТЬ 6 И 7 РАНГ
    sampAddChatMessage(tg..' Функция доступна только лицензёрам.',main_color)
  end
    imgui.End()
  end

if imgui_leakmenu.v then
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.Always)
  imgui.Begin(u8'Налоговая информация.', imgui_leakmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
  if imgui.Button(u8'Представиться',imgui.ImVec2(350, 0)) then
        lua_thread.create(function()
          sampSendChat(privet..', меня зовут '..mainIni.config.name..' '..mainIni.config.surname..'.')
          wait(1000)
          sampSendChat('Вы по вопросу налоговой информации?')
        end)
  end
  if imgui.Button(u8'Попросить документы',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('Хорошо, тогда мне нужно знать от какой компании вы выступаете..')
    wait(1000)
    sampSendChat('..и я хочу увидеть ваши документы.')
    wait(1000)
    sampSendChat('/n компания может быть по вывозу старой мебели, ремонту, химчистки и тд + /pass '..id)
  end)
  end
  if imgui.Button(u8'Проверить лицензию',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('/me достал'..feminism..' КПК с заднего кармана')
    wait(1000)
    sampSendChat('/me открыл'..feminism..' сайт правительства')
    wait(1000)
    sampSendChat('/me просматривает пункт "Лицензии"')
    wait(1000)
    sampSendChat('/do Процесс...')
      wait(4000)
    sampSendChat('/do Лицензия действительна.')
    end)
  end
  if imgui.Button(u8'Открыть кейс и подготовить ценные бумаги',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('/do В руках кейс с ценными бумагами.')
      wait(1000)
      sampSendChat('/me открыл'..feminism..' кейс и достал'..feminism..' все необходимые документы')
      wait(1000)
      sampSendChat('/me взял'..feminism..' ручку и поставил'..feminism..' подпись')
  end)
  end
  if imgui.Button(u8'Передать ценные бумаги',imgui.ImVec2(350, 0)) then
    if leakmenu_buffer_id.v == '' or sampIsPlayerConnected(leakmenu_buffer_id.v) == false then
    sampAddChatMessage(tg..' Сначала введите ID!',main_color)
  else
    lua_thread.create(function()
      sampSendChat('/me передал'..feminism..' ценные бумаги в руки '..sampGetPlayerNickname(leakmenu_buffer_id.v):match('(.+)_')..' '..sampGetPlayerNickname(leakmenu_buffer_id.v):match('_(.+)'))
      wait(1000)
      sampSendChat('/leak '..leakmenu_buffer_id.v..' 15000')
      wait(1000)
      sampSendChat('/me закрыл'..feminism..' кейс.')
      sampSendChat('/c 060')
    end)
  end
  end
  local inputid = imgui.InputText(u8'ID игрока', leakmenu_buffer_id)
  imgui.End()
end

if imgui_obnova.v then
  imgui.ShowCursor = false
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(130, 20), imgui.Cond.Always)
  imgui.Begin(u8'Идёт загрузка..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
  imgui.Text(u8'Идёт обновление...')
  imgui.End()
end


if imgui_obnova_test.v then
  imgui.ShowCursor = false
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(150, 20), imgui.Cond.Always)
  imgui.Begin(u8'Идёт загрузка..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
  imgui.Text(u8'Проверка обновлений...')
  imgui.End()
end


  if imgui_loading.v then
    imgui.ShowCursor = false
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(120, 20), imgui.Cond.Always)
    imgui.Begin(u8'Идёт загрузка..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
    imgui.Text(u8'Идёт загрузка...')
    imgui.End()
  end
if imgui_SB.v then
  local btnSizeSb = imgui.ImVec2(350,0)
  imgui.ShowCursor = true
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(350, 300), imgui.Cond.Always)
  imgui.Begin(u8'Взаимодействие с игроком: '..nickhh..'['..idhh..']',imgui_SB, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
  if imgui.Button(u8'Заломать руку',btnSizeSb) then
    sampAddChatMessage(tg..' Функция в разработке',main_color)
  end
  if imgui.Button(u8'Использовать дубинку',btnSizeSb) then
    sampAddChatMessage(tg..' Функция в разработке',main_color)
  end
  imgui.End()
end
  if imgui_st_sost.v then
    local btnsizesost = imgui.ImVec2(350,0)
    imgui.ShowCursor = true
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(350, 300), imgui.Cond.Always)
    imgui.Begin(u8'Взаимодействие с игроком: '..nickhh..'['..idhh..']',imgui_st_sost,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local namehh, surnamehh = nickhh:match('(.+)_(.+)')
    if imgui.Button(u8'Принять в организацию',btnsizesost) then
      if tonumber(rank) <9 then
        sampAddChatMessage(tg..' Принять в организацию можно с должности Заместитель Мэра[9]',main_color)
      elseif tonumber(rank) >= 9 and mainIni.config.sex == 'Женский' then
        lua_thread.create(function()
        sampSendChat('/do На столе лежит стопка запечатанных рабочих форм.')
        wait(800)
        sampSendChat('/me достала один пакет запечатанной формы')
        wait(800)
        sampSendChat('/me положила рацию на пакет с формой')
        wait(800)
        sampSendChat('/me передала форму и рацию человеку напротив')
        wait(800)
        sampSendChat('/invite '..idhh)
        wait(800)
        sampSendChat('/r Поприветствуем нового сотрудника - '..namehh..' '..surnamehh..'!')
      end)
      else
        lua_thread.create(function()
            sampSendChat('/do На столе лежит стопка запечатанных рабочих форм.')
            wait(800)
            sampSendChat('/me достал один пакет запечатанной формы')
            wait(800)
            sampSendChat('/me положил рацию на пакет с формой')
            wait(800)
            sampSendChat('/me передал форму и рацию человеку напротив')
            wait(800)
            sampSendChat('/invite '..idhh)
            wait(800)
            sampSendChat('/r Поприветствуем нового сотрудника - '..namehh..' '..surnamehh..'!')
        end)
    end
  end
    if imgui.Button(u8'Выдать форму',btnsizesost) then
      if tonumber(rank) < 8 then
        sampAddChatMessage(tg..' Форму можно выдавать только с должности Депутат[8]',main_color)
      elseif tonumber(rank) >= 8 and mainIni.config.sex == 'Женский' then
        lua_thread.create(function()
          sampSendChat('/do В руках запечатанный пакет с формой.')
            wait(800)
          sampSendChat('/me передала пакет в руки '..namehh..' '..surnamehh)
          wait(800)
          sampSendChat('/changeskin '..idhh)
          wait(800)
          sampSendChat('Если форма не подойдёт Вам по размеру, сообщите об этом.')
        end)
      else
          lua_thread.create(function()
          sampSendChat('/do В руках запечатанный пакет с формой.')
            wait(800)
          sampSendChat('/me передал пакет в руки '..namehh..' '..surnamehh)--отыгровка для мужчин
          wait(800)
          sampSendChat('/changeskin '..idhh)
          wait(800)
          sampSendChat('Если форма не подойдёт Вам по размеру, сообщите об этом.')
        end)
        end
     end
    if imgui.Button(u8'Повысить',btnsizesost) then
      if tonumber(rank) < 9 then
        sampAddChatMessage(tg..' Повышать/понижать можно только с должности Заместителя Мэра.',main_color)
      elseif tonumber(rank) >= 9 and mainIni.config.sex == 'Женский' then
        lua_thread.create(function()
      sampSendChat('/do В руках новый бейджик на имя '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me передала новый бейджик человеку напротив')
      wait(800)
      sampSendChat('/rang '..idhh..' +')
      sampSendChat('Поздравляю с новой должностью!')
      end)
      else
        lua_thread.create(function()
      sampSendChat('/do В руках новый бейджик на имя '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me передал новый бейджик человеку напротив') --отыгровка для мужчин
      wait(800)
      sampSendChat('/rang '..idhh..' +')
      sampSendChat('Поздравляю с новой должностью!')
      end)
    end
  end
    if imgui.Button(u8'Понизить',btnsizesost) then
      if tonumber(rank) < 9 then
       sampAddChatMessage(tg..' Повышать/понижать можно только с должности Заместителя Мэра.',main_color)
     elseif tonumber(rank) >= 9 and mainIni.config.sex == 'Женский' then
       lua_thread.create(function()
     sampSendChat('/do В руках новый бейджик на имя '..namehh..' '..surnamehh..'.')
     wait(800)
     sampSendChat('/me передала новый бейджик человеку напротив')
     wait(800)
     sampSendChat('/rang '..idhh..' +')
     end)
     else
        lua_thread.create(function()
      sampSendChat('/do В руках новый бейджик на имя '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me передал новый бейджик человеку напротив')--отыгровка для мужчин
      wait(800)
      sampSendChat('/rang '..idhh..' -')
      end)
     end
   end
    if imgui.Button(u8'Уволить',btnsizesost) then
      if tonumber(rank) >= 8 then
        lua_thread.create(function()
          sampSetChatText('/uninv '..idhh..' ')
          sampSetChatInputEnabled(true)
          sampAddChatMessage(tg..' Введите в чат причину увольнения!',main_color)
        end)
      else sampAddChatMessage(tg..' Увольнять можно только с 8 ранга!',main_color)
      end
    end
    if imgui.Button(u8'Провести инструктаж',btnsizesost) then briefing_SB = true end
    if imgui.CollapsingHeader(u8'Выдать задание') then
      local quest_1 = 'Купи в 24/7 декоративных украшений и укрась холл, просто чтобы красиво.'
      local quest_2 = 'У нас на втором этаже треснула ваза от цветка, найди эту вазу и замени.'
      local quest_3 = 'В конференц. зале перестала работать интерактивная доска, выясни в чём дело'
      local quest_4 = 'В кофеварке, которая за стойкой секретаря на втором этаже, кончилось кофе.'
      local quest_5 = 'У секретаря за стойкой на втором этаже стал глючить компьютер. Разберись.'
      local quest_6 = 'У меня для тебя особенное задание! Купи фотоаппарат в магазине..'
      local quest_7 = 'Изучи какую музыку и в принципе каким искусством увлекается молодёжь...'
      local quest_8 = 'Закупись канцелярией: бумага, ручки, чернила и выгрузи у секретаря.'
      local quest_9 = 'На втором этаже около половины лампочек мерцают, думаю дело в проводке. Выясни.'
      imgui.Text(u8'Задания расставлены по уровню сложности, в \nкаждом из них порядка 3х заданий.')
      if imgui.Button(u8'Первый уровень',btnsizesost) then
        math.randomseed(os.time())
        local first_level = math.random(1, 3)
        if first_level == 1 then
          sampSendChat(quest_1)
        elseif first_level == 2 then
          sampSendChat(quest_2)
        elseif first_level == 3 then
          lua_thread.create(function()
          sampSendChat(quest_4)
          wait(5000)
          sampSendChat('Пойди посмотри что это за кофе, купи такое же в магазине и замени.')
          end)
        end
      end
      if imgui.Button(u8'Второй уровень',btnsizesost) then
        lua_thread.create(function()
        math.randomseed(os.time())
        local second_level = math.random(1, 3)
        if second_level == 1 then
          sampSendChat(quest_7)
          wait(7000)
          sampSendChat('..по этим данным составь статистику или диаграму какую нибудь, результаты к отчёту.')
        elseif second_level == 2 then
          sampSendChat(quest_8)
          wait(1000)
          sampSendChat('/pay '..idhh..' 3000')
        elseif second_level == 3 then
          sampSendChat(quest_3)
        end
      end)
      end
      if imgui.Button(u8'Третий уровень',btnsizesost) then
        lua_thread.create(function()
        math.randomseed(os.time())
        local third_level = math.random(1, 3)
        if third_level == 1 then
          sampSendChat(quest_6)
          wait(6300)
          sampSendChat('..и сделай фотографии напротив больницы '..mainIni.config.podrazd_name..', распечатай фотки..')
          wait(6000)
          sampSendChat('..и оставь их в файлике в кабинете Мэра. К отчёту приложи эл. версию фоток.')
        elseif third_level == 2 then
          sampSendChat(quest_5)
        elseif third_level == 3 then
          sampSendChat(quest_9)
        end
        end)
      end
    end
    imgui.End()
  end

  if imgui_licensor.v then
    local btnsizelic = imgui.ImVec2(350,0)
    imgui.ShowCursor = true
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(350, 295), imgui.Cond.Always)
    imgui.Begin(u8'Взаимодействие с игроком: '..nickhh..'['..idhh..']',imgui_licensor,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    if imgui.Button(u8'Представиться',btnsizelic) then
      lua_thread.create(function()
        sampSendChat(privet..', я '..rankname..' - '..mainIni.config.name..' '..mainIni.config.surname..'.')
        wait(500)
        sampSendChat('Вы хотите приобрести лицензию?')
      end)
    end
    if imgui.Button(u8'Рассказать о различных типах лицензий',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('Вы можете приобрести всего 2 типа лицензий: ')
        wait(500)
        sampSendChat('Профессиональные права, которые включают лицензию на воздушный и водный транспорт..')
        wait(800)
        sampSendChat('..и лицензию на оружие. Стоимость их 10.000$ и 30.000$ соотвественно, оплата наличными.')
    end)
    end
    if imgui.Button(u8'Попросить имя и фамилию и документы',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('Мне нужно, чтобы Вы назвали своё имя, фамилию...')
        wait(500)
        sampSendChat('..и показали мне свой паспорт с пакетом лицензий.')
        wait(800)
        sampSendChat('/n /pass '..id..' /lic '..id)
      end)
    end
    if imgui.Button(u8'Начать оформление',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('/do В руках кейс с нужными документами.')
          wait(800)
        sampSendChat('/me открыл кейс и достал документы с ручкой с него')
        wait(800)
        sampSendChat('/me начал заполнение документов на имя '..nickhh)
        wait(800)
        sampSendChat('/todo Указав на поля для подписей пальцем*Вам нужно здесь расписаться')
        wait(100)
        sampSendChat('/n /me расписался(ась)')
      end)
    end
    if imgui.Button(u8'Выдать права на вождение',btnsizelic) then
      sampAddChatMessage(tg..' Выдавать права на вождение запрещено законом федерации.',main_color)
    end
    if imgui.Button(u8'Выдать профессиональные права',btnsizelic) then
      sampSendChat('/givelic '..idhh..' 1 10000')
    end
    if imgui.Button(u8'Выдать права на оружие',btnsizelic) then
      lua_thread.create(function()
      sampSendChat('/givelic '..idhh..' 2 30000')
      if msgmm:find('У гражданина уже есть данный тип лицензии') then
        sampAddChatMessage(tg..' У игрока есть уже этот тип лицензии', main_color)
        sampSendChat('Вы не нуждаетесь в данном виде лицензии, вы уже владеете ею.')
        wait(1000)
        sampSendChat('/me зачеркнул бумаги, положил их в специальное отделение...')
        wait(1000)
        sampSendChat('/me ..и закрыл кейс')
      elseif msgmm:find('У гражданина нет такой суммы') then
        sampAddChatMessage(tg..' У игрока нет столько денег',main_color)
        sampSendChat('К сожалению, я не могу оформить на Вас эту лицензию.')
        wait(1000)
        sampSendChat('У Вас недостаточно денег. Возвращайтесь, когда будет 30.000$')
        wait(1000)
        sampSendChat('/me зачеркнул бумаги, положил их в специальное отделение...')
        wait(1000)
        sampSendChat('/me ..и закрыл кейс')
      else sampSendChat('/me спрятал ненужные бумаги с ручкой в кейс и закрыл его')
      end
    end)
    end
    if imgui.Button(fa.ICON_ID_CARD_O..u8' Выдать визитку',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('Спасибо, что выбрали меня в качестве лицензёра.')
        wait(800)
        sampSendChat('Можете обращаться ко мне или рекомендовать меня своим знакомым.')
        wait(800)
        sampSendChat('/me передал'..feminism..' визитку клиенту')
        wait(800)
        sampSendChat('/do Надпись на визитке: '..rankname..' | '..mainIni.config.phone_number..' | '..mainIni.config.podrazd_name..'.')
          promo_1 = string.match(mainIni.config.name,'(.)')
          wait(800)
        sampSendChat('По промокоду #'..mainIni.config.phone_number..promo_1..mainIni.config.podrazd_name..' Вы получите кэшбек 20 процентов!')
      end)
    end
    imgui.End()
  end

  if imgui_lawyer.v then
    imgui.ShowCursor = true
    local btnsizelawyer = imgui.ImVec2(400,0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 450), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Взаимодействие с игроком: '..nickhh..'['..idhh..']',imgui_lawyer,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local butlawyer_0 = imgui.Button(u8'Проверить человека на ООП',btnsizelawyer)
    local butlawyer_1 = imgui.Button(u8'Освободить человека по RolePlay',btnsizelawyer)
    if butlawyer_0 then idf = idhh
      lua_thread.create(function()
      sampSendChat('/me достал КПК')
       wait(500)
       sampSendChat('/me зашел в Базу Данных МВД и ввёл имя и фамилию нужного человека')
       wait(1000)
      sampSendChat('/free '..idhh..' 0')
      checkf = 'true'
    end)
     end
    if butlawyer_1 then
        freeid = idhh
        if tonumber(rank) ~= 5 then sampSendChat('/free '..freid)
        elseif #freid ~= 0 and tonumber(rank) == 5 and freedom ~= 'start' then sampAddChatMessage(tg..' Введите ID игрока или закончите с предыдущим. (Клавиша "K" для отмены)',main_color)
      else
        math.randomseed(os.time())
        rand_free = math.random(0, 3)
          rpnamefree, rpsurnamefree = string.match(sampGetPlayerNickname(idhh), '(.+)_(.+)')
          if rand_free == 0 then
            sampSendChat('Если вы хотите воспользоваться услугами адвоката, назовите своё имя и фамилию.')
          elseif rand_free == 1 then
            sampSendChat('Вы можете воспользоваться услугами профессионального адвоката '..mainIni.config.podrazd_name)
            sampSendChat('Для этого просто назовите своё имя и фамилию.')
          elseif rand_free == 2 then
            sampSendChat('Здравствуйте, Вы можете нанять адвоката для УДО. Просто назовите своё имя и фамилию.')
          elseif rand_free == 3 then
            sampSendChat('Вы можете воспользоваться моими услугами адвоката, для начала представьтесь.')
          end
          lua_thread.create(function()
            wait(200)
          sampAddChatMessage(tg..' Нажмите клавишу "J", чтобы продолжить или "K" для отмены.',main_color)
          freedom = 1
        end)
        end
    end
    imgui.End()
  end


  if imgui_gnews.v then
    local btnsizegnews = imgui.ImVec2(300, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(450, 350), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Государственная волна',imgui_gnews, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.TextQuestion2(u8"( ? )", u8"Тэг организации и команду /gnews вводить НЕ нужно!")
    imgui.Text(u8'3 строки:')
    local input1 = imgui.InputText(u8'##1', gnews_text_buffer_1)
    if input1 then mainIni.settings.gnews_line_1 = gnews_text_buffer_1.v end
    local input2 = imgui.InputText('##2', gnews_text_buffer_2)
    if input2 then mainIni.settings.gnews_line_2 = gnews_text_buffer_2.v end
    imgui.SameLine()
    if imgui.Button(u8'Отправить 3 строки',imgui.ImVec2(145,0)) then
      if tonumber(rank) >= 10 then
      sampAddChatMessage(tg..' ',main_color)
    else sampAddChatMessage(tg..' Вещание в гос. волну доступно только лидерам организации.',main_color)
      end
    end
    local input3 = imgui.InputText('##3', gnews_text_buffer_3)
    if input3 then mainIni.settings.gnews_line_3 = gnews_text_buffer_3.v end
    imgui.Text(u8'Продолжение:')
    local input4 = imgui.InputText('##4', gnews_text_buffer_4)
    if input4 then mainIni.settings.gnews_line_4 = gnews_text_buffer_4.v end
    imgui.SameLine()
    if imgui.Button(u8'Отправить продолжение',imgui.ImVec2(145,0)) then
      if tonumber(rank) >= 10 then
      sampAddChatMessage(tg..' ',main_color)
    else sampAddChatMessage(tg..' Вещание в гос. волну доступно только лидерам организации.',main_color)
      end
    end
    imgui.Text(u8'Конец:')
    local input5 = imgui.InputText('##5', gnews_text_buffer_5)
    if input5 then mainIni.settings.gnews_line_5 = gnews_text_buffer_5.v end
    imgui.SameLine()
    if imgui.Button(u8'Отправить конец',imgui.ImVec2(145,0)) then
            if tonumber(rank) >= 10 then
            sampAddChatMessage(tg..' ',main_color)
          else sampAddChatMessage(tg..' Вещание в гос. волну доступно только лидерам организации.',main_color)
            end
    end
    imgui.Text(u8'\nТочное время: '..os.date('%H:%M:%S'))
    local proverka = imgui.Button(u8'Проверить',imgui.ImVec2(145,0))
    imgui.SameLine()
    local sohranit = imgui.Button(u8'Сохранить',imgui.ImVec2(145,0))
    imgui.SameLine()
    local sbrosit = imgui.Button(u8'Сбросить настройки',imgui.ImVec2(145, 0))
    if sbrosit then
      mainIni.settings.gnews_line_1 = 'РЈРІ. Р¶РёС‚РµР»Рё Р¤РµРґРµСЂР°С†РёРё, РјРёРЅСѓС‚Сѓ РІРЅРёРјР°РЅРёСЏ!'
      mainIni.settings.gnews_line_2 = 'РџСЂРѕС…РѕРґРёС‚ СЃРѕР±РµСЃРµРґРѕРІР°РЅРёРµ РІ РјСЌСЂРёСЋ Рі.Los-Santos! РўСЂРµР±РѕРІР°РЅРёСЏ:..'
      mainIni.settings.gnews_line_3 = '..4 РіРѕРґР° РІ Р¤РµРґРµСЂР°С†РёРё, РїР°РєРµС‚ РґРѕРєСѓРјРµРЅС‚РѕРІ Рё СѓР»С‹Р±РєР° РЅР° Р»РёС†Рµ. GPS: 3-3'
      mainIni.settings.gnews_line_4='РќР°РїРѕРјРёРЅР°СЋ, РїСЂРѕС…РѕРґРёС‚ СЃРѕР±РµСЃРµРґРѕРІР°РЅРёРµ РІ РњСЌСЂРёСЋ Los-Santos. GPS: 3-3.'
      mainIni.settings.gnews_line_5='РЎРѕР±РµСЃРµРґРѕРІР°РЅРёРµ РІ РњСЌСЂРёСЋ Los-Santos Р·Р°РєРѕРЅС‡РµРЅРѕ. Р’СЃРµРј СЃРїР°СЃРёР±Рѕ!'
      sampAddChatMessage(tg..' Настройки успешно сброшены!',main_color)
    end
    if proverka then
      lua_thread.create(function()
      sampAddChatMessage('/gnews G | '..u8:decode(mainIni.settings.gnews_line_1),main_color)
      wait(1000)
      sampAddChatMessage('/gnews G | '..u8:decode(mainIni.settings.gnews_line_2),main_color)
      wait(1000)
      sampAddChatMessage('/gnews G | '..u8:decode(mainIni.settings.gnews_line_3),main_color)
      sampAddChatMessage('',main_color)
      wait(1000)
      sampAddChatMessage('/gnews G | '..u8:decode(mainIni.settings.gnews_line_4),main_color)
      sampAddChatMessage('',main_color)
      wait(1000)
      sampAddChatMessage('/gnews G | '..u8:decode(mainIni.settings.gnews_line_5),main_color)
    end)
    end
    if sohranit then
      inicfg.save(mainIni, directIni)
      sampAddChatMessage(tg..' Успешно сохранено!',main_color)
    end
    imgui.End()
  end
  if imgui_mainmenu.v then
    local chosesize = imgui.ImVec2(150, 0)
    local actionsize = imgui.ImVec2(380, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.Always)
    imgui.Begin(u8'Главное меню', imgui_mainmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.BeginChild('Chose menu', imgui.ImVec2(170, 300), true)
    imgui.Text(u8'Выберите необходимую\n\t\t Вам должность')
    if imgui.Button(u8'[1]Сотрудник СБ', chosesize) then main_rank = 1 end
    if imgui.Button(u8'[2]Начальник СБ', chosesize) then main_rank = 2 end
    if imgui.Button(u8'[3]Соц работник', chosesize) then main_rank = 3 end
    if imgui.Button(u8'[4]Секретарь', chosesize) then main_rank = 4 end
    if imgui.Button(u8'[5]Юрисконсульт', chosesize) then main_rank = 5 end
    if imgui.Button(u8'[6]Инструктор', chosesize) then main_rank = 6 end
    if imgui.Button(u8'[7]Лицензёр', chosesize) then main_rank = 7 end
    if imgui.Button(u8'[8]Депутат СБ', chosesize) then main_rank = 8 end
    if imgui.Button(u8'[9]Заместитель Мэра', chosesize) then main_rank = 9 end
    if imgui.Button(u8'[10]Мэр города', chosesize) then main_rank = 10 end
    if imgui.Button(u8'[all]Flooder', chosesize) then main_rank = 11 end
    imgui.EndChild()
    imgui.SameLine()
    imgui.BeginChild('action menu', imgui.ImVec2(415,300),true)
    if main_rank == 1 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      local autodokl = imgui.Button(u8'Вкл/выкл автодоклады в рацию',actionsize)
      if autodokl and tonumber(rank) > 1 then
        sampAddChatMessage(tg..' Ты уже '..rankname..', зачем тебе доклады?)',main_color)
      elseif autodokl and tonumber(rank) == 1 then
        sampAddChatMessage(tg..' На Blue пока не требуются доклады в рацию для повышения, можете просто гулять по мэрии :)',main_color)
      end
    elseif main_rank == 2 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      local autootvet = imgui.Button(u8'Вкл/выкл ответ на доклады',actionsize)
      if autootvet and tonumber(rank) == 2 then
        sampAddChatMessage(tg..' На Blue для отчётов не нужны доклады в рацию, соответственно принимать их тоже не имеет смысла.',main_color)
        sampAddChatMessage(tg..' Попробуйте провести какое-то мероприятие для сотрудников СБ :)',main_color)
      elseif autootvet and tonumber(rank) ~= 2 then
        sampAddChatMessage(tg..' Фукнция работает только для начальников СБ.', main_color)
      end


    elseif main_rank == 3 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end

      if imgui.CollapsingHeader(u8'Соц. опросы') then
        lua_thread.create(function()

      if imgui.Button(u8'Представиться, пригласить поучаствовать в опросе.',actionsize) then
        sampSendChat('Здравствуйте, я '..mainIni.config.rankname..', из '..mainIni.config.podrazd)
        wait(800)
        sampSendChat('Не желаете поучаствовать в социальном опросе? Все ответы анонимны.')
      end
    end)

      if imgui.Button(u8'Достать/спрятать блокнот',actionsize) then

        if notebook == nil or notebook == false then
          lua_thread.create(function()
          notebook = true
          sampSendChat('/do Висит сумка через плечо.')
          wait(500)
          sampSendChat('/me открыл'..feminism..' сумку и достал'..feminism..' блокнот с чёрной гелевой ручкой')
          wait(500)
          sampSendChat('/me открыл'..feminism..' блокнот на дате '..os.date('%D')..', после закрыл'..feminism..' сумку')
        end)
        elseif notebook == true then
          sampSendChat('/me открыл сумку, кинул в неё ручку и блокнот, после закрыл')
          notebook = false
        end
      end
      local bloknot = imgui.Button(u8'Сделать запись в блокнот',actionsize)

      if bloknot and notebook then
        sampSendChat('/me сделал'..feminism..' запись в блокнот')
      elseif bloknot and not notebook then
        sampAddChatMessage(tg..' Для начала достань блокнот!',main_color)
      end

      if imgui.Button(u8'Задать вопрос о политике',actionsize) then
        math.randomseed(os.time())
        local rand_polit = math.random(0, 3)

        if rand_polit == 0 then
          sampSendChat('Как вы относитесь к нашему президенту?')
        elseif rand_polit == 1 then
          sampSendChat('Что вы думаете насчёт депутатов '..mainIni.config.podrazd..'?')
        elseif rand_polit == 2 then
          sampSendChat('Вы замечаете работу нашего филиала? Что-то меняется в федерации?')
        elseif rand_polit == 3 then
          sampSendChat('Вы принимаете участие в выборах президента?')
        end
      end

      if imgui.Button(u8'Спросить об отношении к МВД',actionsize) then
        math.randomseed(os.time())
        local rand_MVD = math.random(0, 3)

        if rand_MVD == 0 then
        sampSendChat('Какое ваше отношение в целом к МВД?')
      elseif rand_MVD == 1 then
        sampSendChat('Предложите хоть 1 улучшение или реформирование для МВД, что улучшило бы его.')
      elseif rand_MVD == 2 then
        sampSendChat('Вы когда-нибудь замечали несанкционированную работу сотрудников МВД? Расскажите об этом')
      elseif rand_MVD == 3 then
        sampSendChat('Если бы ваш друг стал полицейским, ваша реакция?')
      end
    end
      if imgui.Button(u8'Задать вопрос о МЗ.',actionsize) then
        math.randomseed(os.time())
        local rand_MZ = math.random(0, 3)
        if rand_MZ == 0 then
        sampSendChat('Что вы можете сказать насчёт мин. здравоохранения?')
      elseif rand_MZ == 1 then
        sampSendChat('Вас устраивает цена на медицинское обслуживание в '..mainIni.config.podrazd_name..'?')
      elseif rand_MZ == 2 then
        sampSendChat('Оцените работу МЗ по 10 балльной шкале, где 1 - ужасно, а 10 - отлично.')
      elseif rand_MZ == 3 then
        sampSendChat('Возможно у Вас есть идеи по улучшению МЗ? Расскажите про это')
      end
    end
      if imgui.Button(u8'Поблагодарить человека за участие',actionsize) then
        sampSendChat('Благодарю Вас за участие в соц опросе, Вы очень помогли федерации!')
      end
  end


    elseif main_rank == 4 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      if imgui.Button(fa.ICON_ID_CARD_O..u8' Выдать визитку адвокатов/лицензёров',actionsize) then
        lua_thread.create(function()
        sampSendChat('/do На столе стопка визиток.')
          wait(800)
        sampSendChat('/me вытащил'..feminism..' одну визитку и передал'..feminism..' человеку напротив')
        wait(500)
        sampSendChat('/n /liclist - список лицензёров | /adlist - список адвокатов.')
      end)
      end
    elseif main_rank == 5 then
      imgui.TextQuestion2(fa.ICON_EYE, u8'Основной функционал спрятан в команде взаимодействия(/hh id)')
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      local proverkall = imgui.Button(u8'Проверить всех вокруг на ООП',actionsize)
      if proverkall and tonumber(rank)~=5 then
        sampAddChatMessage(tg..' Функция доступна только для адвокатов[5]. :(',main_color)
      elseif proverkall and tonumber(rank) == 5 then
      if checkall == true then checkall = false
        sampAddChatMessage(tg..' Проверка завершена.',main_color)
          elseif checkall == false then
            checkall = true
            sampAddChatMessage(tg..' Проверка начата!',main_color)
          lua_thread.create(function()
          for k, v in pairs(getAllChars()) do
            _, idmm = sampGetPlayerIdByCharHandle(v)
            sampSendChat("/free "..idmm..' 0')
            wait(1000)
            if msgmm:find('Укажите сумму от 9000$ до 30000$') or msgmm:find('Ваш клиент слишком далеко') then
              sampAddChatMessage(tg..' {FF8C00}Внимание!{CECECE} Игрок '..sampGetPlayerNickname(idmm)..'['..idmm..'] - {00FF00}не ООП{CECECE}!',main_color)
        end
          end
        end)
      end
      if imgui.Button(u8'Пропиариться(/ad)',actionsize) then
        sampSendChat('/ad Работает адвокат от '..mainIni.config.podrazd..'. Звоните!')
      end
      end
    elseif main_rank == 6 then
      imgui.TextQuestion2(fa.ICON_EYE, u8'Основной функционал спрятан в команде взаимодействия(/hh id)')
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Желаете приобрести лицензию?')
        end)
    end
      if imgui.Button(u8'Пропиариться(/ad)',actionsize) then
        sampSendChat('/ad Работает лицензёр от '..mainIni.config.podrazd..'. Звоните!')
      end
      if imgui.Button(u8'Провести инструктаж для охраны',actionsize) then
        briefing_SB = true
      end
      if imgui.CollapsingHeader(u8'Инструктаж') then
        lua_thread.create(function()
          local start = imgui.Button(u8'Приветствие',actionsize)
          local theend = imgui.Button(u8'Завершить инструктаж(в конце поездки)', actionsize)
          if start then
            briefing = true
            sampSendChat(privet..', я ваш инструктор по вождению - '..mainIni.config.name..' '..mainIni.config.surname..'!')
            wait(800)
            sampSendChat('Я буду с Вами кататься по городу и при необходимости подсказывать.')
            wait(800)
            sampSendChat('В случае, если Вы успешно пройдёте практическую часть, вы получите...')
            wait(800)
            sampSendChat('..скидку на профессиональные права от меня, это Вам обойдётся в 5.000$ вместо 10.000$')
            wait(800)
            sampSendChat('Задавайте вопросы во время поездки, если они у Вас появятся.')
        elseif theend and briefing == true then
            briefing = false
            sampSendChat('Поздравляю с успешной сдачей практической части, сейчас Вы получите ваши права.')
            wait(800)
            sampSendChat('Хочу напомнить про скидку на профессиональные права в 50#, они Вам...')
            wait(800)
            sampSendChat('Обойдутся в 5.000$, вместо 10.000$ без скидки.')
            wait(500)
            sampAddChatMessage(tg..' Не забудьте сделать скриншот!',main_color)
            sampSendChat('/c 060')
          elseif theend and briefing == false then
            sampAddChatMessage(tg..' Для начала начните инструктаж!',main_color)
          end
        end)
      end
    elseif main_rank == 7 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Желаете приобрести лицензию?')
        end)
    end
      if imgui.Button(u8'Пропиариться(/ad)',actionsize) then
        sampSendChat('/ad Работает лицензёр от '..mainIni.config.podrazd..'. Звоните!')
      end
    elseif main_rank == 8 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      if imgui.Button(u8'Опечатать здание',actionsize) then
        sampAddChatMessage(tg..' Функция находится в разработке.',main_color)
      end
    elseif main_rank == 9 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      if imgui.Button(u8'ДАТЬ ПИЗДЫ',actionsize) then
        sampAddChatMessage(tg..' Функция находится в разработке.',main_color)
      end
    elseif main_rank == 10 then
      if imgui.Button(u8'Представиться',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', я '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('Вам что-нибудь подсказать?')
        end)
    end
      if imgui.Button(u8'Уничтожить штат',actionsize) then
        sampAddChatMessage(tg..' Функция находится в разработке.',main_color)
      end
    elseif main_rank == 11 then
      if imgui.Button(u8'Вкл/выкл флудер', actionsize) then
        flooder = not flooder
        sampAddChatMessage(tg..' Успешно!',main_color)
      end
      imgui.InputText('##1', bufferflooder)
      imgui.Text(u8'Введённая команда: '..bufferflooder.v)
      imgui.Text(u8'Активация: клавиша K')
      if flooder then
      imgui.Text(u8'Флудер: активирован.')
      else
        imgui.Text(u8'Флудер: неактивен.')
      end
    end
    imgui.EndChild()
    imgui.End()
  end
  if imgui_note.v then
    inicfg.load(nil, directIni)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Government Helper - заметки', imgui_note, imgui.WindowFlags.NoCollapse)
    local multiinput = imgui.InputTextMultiline("##1", note_text_buffer, imgui.ImVec2(600, 350))
    if multiinput then
      mainIni.note.text = note_text_buffer.v
      inicfg.save(mainIni, directIni)
    end
    imgui.End()
  end
  if imgui_bl.v then
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'ЧС', imgui_bl)
    textbl = ''
    for line in io.lines(getWorkingDirectory()..'/Government Helper/bl.txt') do
      lua_thread.create(function()
      nicknime, reasonb, termb = line:match('(.+) | (.+) | (.+)')
      wait(50)
      textbl = textbl..'\n'..nicknime..' | '..reasonb..' | '..termb
      --sampAddChatMessage(nicknime..' | '..u8:decode(reasonb)..' | '..u8:decode(termb),main_color)
    end)
    end
    imgui.Text(textbl)
      imgui.End()
  end
end

----------------------------------------------------------------------------------БЛОК КОМАНД-----------------------------------------------------------------------------------
function cmd_qq()
lua_thread.create(function()
  if tonumber(rank) <5 or tonumber(rank) > 7 then
  sampSendChat('Здравствуйте, я '..rankname..' - '..name..' '..surname..'!')
  wait(500)
  sampSendChat('/do Висит бейджик: '..rankname..' | '..name..' '..surname..' | '..number)
  wait(500)
  sampSendChat('Чем я могу Вам помочь?')
elseif tonumber(rank) == 5 then
  sampSendChat('Здравствуйте, я '..rankname..' - '..name..' '..surname..'!')
  wait(800)
  sampSendChat('Вы нуждаетесь в услугах адвоката?')
  wait(800)
  sampSendChat('Это будет стоить Вам 10.000$, если вы из гос. организации или 9.000$, если нет.')
elseif tonumber(rank) == 6 or tonumber(rank) == 7 then
  sampSendChat('Здравствуйте, я '..rankname..' - '..name..' '..surname..'!')
  wait(800)
  sampSendChat('Не желаете приобрести лицензию?')
  wait(800)
  sampSendChat('В наличии проф. права по цене 10.000$ и лицензия на оружие - 30.000$')
end
end)
end

function fraction_cmd(fraction)
  if #fraction == 0 then sampSendChat('/f')
  elseif #fraction ~= 0 and mainIni.settings.rpradio == true then
    sampSendChat('/f '..fraction)
    sampSendChat('/me передал'..feminism..' что-то по рации')
  elseif mainIni.settings.rpradio == false then
    sampSendChat('/f '..fraction)
    sampUnregisterChatCommand('f')
  end
end

function podrazd_cmd (podrazd_text)
  if #podrazd_text == 0 then sampSendChat('/r')
  elseif #podrazd_text ~= 0 and mainIni.settings.rpradio == true then
    sampSendChat('/r '..podrazd_text)
    sampSendChat('/me передал'..feminism..' что-то по рации')
  elseif mainIni.settings.rpradio == false then
    sampSendChat('/r '..podrazd_text)
    sampUnregisterChatCommand('r')
  end
end

function cmd_rr(RadioOOC)
  if #RadioOOC == 0 then sampAddChatMessage(tg..' Чтобы написать ООС сообщение в чат подразделения введите /rr [текст].',main_color)
  else  sampSendChat('/r (( '..RadioOOC..' ))') end
end

function cmd_ff(FractionOOC)
  if #FractionOOC == 0 then sampAddChatMessage(tg..' Чтобы написать ООС сообщение в чат организации введите /ff [текст].',main_color)
  else sampSendChat('/f (( '..FractionOOC..' ))') end
end


function imgui.TextQuestion2(label, text)
    imgui.TextDisabled(label)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end


function inv_cmd(inv_id)
  if tonumber(rank) < 9 then sampAddChatMessage(tg..' Принимать сотрудников можно с должности "Заместитель мэра" и выше.',main_color)
  elseif #inv_id == 0 then sampAddChatMessage(tg..' Для того, чтобы пригласить человека в организацию введите /inv ID!',main_color)
  else
    lua_thread.create(function()
    sampSendChat('Сейчас я выдам Вам вашу рацию. Форму можете взять в шкафу на 2 этаже.')
    wait(800)
    sampSendChat('/do В руках кейс с рациями.')
      wait(800)
      i_p_n = string.match(sampGetPlayerNickname(inv_id), '(.+)_')
    if sex == 'Мужской' then
      sampSendChat('/me открыл кейс с рациями и передал одну в руки '..i_p_n)
    elseif sex == 'Женский' then
      sampSendChat('/me открыла кейс с рациями и передала одну в руки '..i_p_n)
    end
    wait(800)
    sampSendChat('/invite '..inv_id)
    local name_inv, surname_inv = string.match(sampGetPlayerNickname(inv_id), '(.+)_(.+)')
    sampSendChat('/r Поприветствуем нового сотрудника мэрии - '..name_inv..' '..surname_inv..'!')
  end)
  end
end

  function hiist_cmd(arg)
    if #arg == 0 then sampAddChatMessage(tg..' Чтобы проверить историю ника человека по его ID введите /hist ID',main_color)
    else
      histnick = sampGetPlayerNickname(arg)
       sampSendChat('/history '..histnick)
    end
  end

  function cmd_hh(hhid)
    if #hhid == 0 and interaction_window.v == true then interaction_window.v = not interaction_window.v
    elseif #hhid == 0 then sampAddChatMessage(tg..' Введите ID нужного игрока для взаимодействия.',main_color)
    elseif not sampIsPlayerConnected(hhid) then sampAddChatMessage(tg..' Введите корректно ID игрока для взаимодействия.',main_color)
  else
    idhh = hhid
    nickhh = sampGetPlayerNickname(idhh)
    interaction_window.v = not interaction_window.v
    end
  end

  function invite_cmd(idinv)
    if #idinv == 0 or rank <9 then sampSendChat('/invite')
    else
      nickinv = sampGetPlayerNickname(idinv)
      rpnameinv, rpsurnameinv = string.match(nickinv, '(.+)_(.+)')
      sampSendChat('/r Поприветствуем нового сотрудника - '..rpnameinv..' '..rpsurnameinv..'!')
      sampSendChat('/invite '..idinv)
    end
  end

function checkf_cmd(idf)
  if #idf == 0 then sampAddChatMessage(tg..' Введите ID игрока, которого нужно проверить',main_color)
  elseif rank ~= '5' then sampAddChatMessage(tg..' Функция доступна только адвокатам.',main_color)
  else
    lua_thread.create(function()
    sampSendChat('/me достал КПК')
     wait(500)
     sampSendChat('/me зашел в Базу Данных МВД и ввёл имя и фамилию нужного человека')
     wait(1000)
    sampSendChat('/free '..idf..' 9000')
    checkf = 'true'
    wait(200)
    sampSendChat('/cancel')
    end)
  end
end

freedom = 'start'
function fre_cmd(freid)
  freeid = freid
  if rank ~= '5' then sampSendChat('/free '..freid)
  elseif #freid == 0 and rank == '5' then sampAddChatMessage(tg..' Чтобы освободить игрока, введите /fre ID',main_color)
  elseif #freid ~= 0 and rank == '5' and freedom ~= 'start' then sampAddChatMessage(tg..' Введите ID игрока или закончите с предыдущим. (Клавиша "K" для отмены)',main_color)
else
  math.randomseed(os.time())
  rand_free = math.random(0, 3)
    rpnamefree, rpsurnamefree = string.match(sampGetPlayerNickname(freid), '(.+)_(.+)')
    if rand_free == 0 then
      sampSendChat('Если вы хотите воспользоваться услугами адвоката, назовите своё имя и фамилию.')
    elseif rand_free == 1 then
      sampSendChat('Вы можете воспользоваться услугами профессионального адвоката '..mainIni.config.podrazd_name)
      sampSendChat('Для этого просто назовите своё имя и фамилию.')
    elseif rand_free == 2 then
      sampSendChat('Здравствуйте, Вы можете нанять адвоката для УДО. Просто назовите своё имя и фамилию.')
    elseif rand_free == 3 then
      sampSendChat('Вы можете воспользоваться моими услугами адвоката, для начала представьтесь.')
    end
    lua_thread.create(function()
      wait(200)
    sampAddChatMessage(tg..' Нажмите клавишу "J", чтобы продолжить или "K" для отмены.',main_color)
    freedom = 1
  end)
  end
end


function uninv_cmd(uninvarg)
  ID_uninv, reason_uninv = string.match(uninvarg,'(%d+) (.+)')
  if #uninvarg == 0 then
    sampAddChatMessage(tg..' Для того, чтобы выгнать человека из организации введите /uninv ID *причина*!',main_color)
  elseif ID_uninv == nil or reason_uninv == nil then sampAddChatMessage(tg..' Ошибка! Вы не ввели причину или ID. /uninv ID *причина*!',main_color)
  elseif tonumber(rank) <8 then sampAddChatMessage(tg..' Увольнять можно с должности Депутат[8] и выше',main_color)
  else
    u_p_n, u_p_s = string.match(sampGetPlayerNickname(ID_uninv), '(.+)_(.+)')
    lua_thread.create(function()
    if mainIni.config.sex == 'Мужской' then
      sampSendChat('/me достал КПК и открыл Базу Данных сотрудников Правительства')
      wait(800)
      sampSendChat('/me выбрал нужного человека и нажал "Уволить"')
      wait(800)
      sampSendChat('/r Аннулировал дело сотрудника '..u_p_n..' '..u_p_s..'по причине: '..reason_uninv)
    elseif mainIni.config.sex == 'Женский' then
      sampSendChat('/me достала КПК и открыла Базу Данных сотрудников Правительства')
      wait(800)
      sampSendChat('/me выбрала нужного человека и нажала "Уволить"')
      wait(800)
      sampSendChat('/r Аннулировала дело сотрудника '..u_p_n..' '..u_p_s..'по причине: '..reason_uninv)
      end
    end)
    end
end


  function addbl_cmd(addblarg)
    if #addblarg == 0 then sampAddChatMessage(tg..' Чтобы добавить игрока в локальный ЧС, введите /addbl [id/nickname] [причина]',main_color) return end
    ID_bl, reason_bl = addblarg:match('(.+) (.+)')
    local nickbl = sampGetPlayerNickname(tonumber(ID_bl))
  if ID_bl == 0 or reason_bl == 0 then sampAddChatMessage(tg..' {8B0000}Ошибка! {CECECE}Вы не ввели ID игрока или причину.',main_color) return end
  if tonumber(ID_bl) ~= nil then
    if sampIsPlayerConnected(tonumber(ID_bl)) then
      local file = io.open(getWorkingDirectory()..'/Government Helper/lblacklist.txt', 'a+')
      file:write(nickbl..' - '..reason_bl..'\n')
      file:close()
      sampAddChatMessage(tg..' Вы успешно внесли игрока '..nickbl..'['..ID_bl..'] в локальный ЧС (/lbl) по причине: '..reason_bl..'.',main_color)
    else sampAddChatMessage(tg..' Игрок не найден.',main_color)
    end
        else
        local file = io.open(getWorkingDirectory()..'/Government Helper/lblacklist.txt', 'a+')
        sampAddChatMessage(tg..' Вы успешно внесли игрока '..ID_bl..' в локальный ЧС (/lbl) по причине: '..reason_bl..'.',main_color)
        file:write(ID_bl..' - '..reason_bl..'\n')
        file:close()
    end
  end


  function cmd_lbl()
    local text = 'Игрок\tПричина'
        for line in io.lines(getWorkingDirectory().."/Government Helper/lblacklist.txt") do
            local nick, reason = line:match('(.+) %- (.+)')
            text = text..'\n'..nick..'\t'..reason
        end
        sampShowDialog(22228, "чёрный список", text, "Изменить", "Ок", 5)
        local result, button, list, input = sampHasDialogRespond(22228)
          if result then
            if list == 0 then
        if button == 1 then sampAddChatMessage(tg..' Функция в разработке. Пока отредактировать ЧС вы можете в moonloader -> Government Helper -> lblacklist.txt',main_color)
        else return end
      end
      end
    end
