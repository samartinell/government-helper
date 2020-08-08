script_name('Government helper')
script_author('samartinell')
script_version = 'v. 1.6 Alpha'
script_vers = 1.6

require 'lib.sampfuncs'
require "lib.moonloader" -- ����������� ���������� ����������
local keys = require "vkeys" -- ����������� ���� ������
local sampev = require 'lib.samp.events' --����������� ���������� ��� ���������� ������� �� �������
local font_flag = require('moonloader').font_flag -- ������
local memory = require 'memory' -- ����������� ����������
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
local my_font = renderCreateFont('TimesNewRoman', 12, font_flag.BOLD + font_flag.SHADOW) -- �������� �����
local checkall = false
local lic = 0
local flooder=false

if not doesFileExist(getWorkingDirectory()..'/Government Helper/lblacklist.txt') then -- �������� �����, ���� ��� ���
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

--��������������
local dlstatus = require('moonloader').download_status
update_state = false
local update_url = "https://raw.githubusercontent.com/samartinell/government-helper/master/update.ini" -- ������ �� ������
local update_path = getWorkingDirectory() .. "/update.ini" -- ������ �� ����

local script_url = "https://github.com/samartinell/government-helper/blob/master/GHelper.luac?raw=true" -- ������ �� ������
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
              sampAddChatMessage(tg.." ���� ����������! ������: " .. updateIni.info.vers_text, main_color)
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
  sampRegisterChatCommand('leakmenu',function() if tonumber(mainIni.config.rank) <5 then sampAddChatMessage(tg..' ��������� ��������� ���������� ����� ������ � ��������� �������[5]',main_color) else imgui_leakmenu.v = not imgui_leakmenu.v end end)
  privetstvie = 'true'
  crashaa = false
  sampAddChatMessage(tg..' ���������, ������ �����������...', main_color)
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
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- ��������� ���� ������
    nickname = sampGetPlayerNickname(id) -- ��������� �������� ������
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
                sampAddChatMessage(tg.." ������ ������� ��������!", main_color)
                thisScript():reload()
            end
        end)
        break
    end

    if proverkalic then
      if lic == 2 then
        proverkalic = false
        sampAddChatMessage(tg..' ������� ��������!',main_color)
        lic = 0
      elseif lic <2 then
        proverkalic = false
        sampAddChatMessage(tg..' ������� �� ��������',main_color)
        lic = 0
        sobes = 9
      end
    end

if crashaa then
  print('������ ��� ��������. ��� ������������ ������� CTRL+R')
  thisScript():crash()
  repeat
    wait(100000)
  until soadkoksd == true
end

    if privetstvie == 'true' then
      math.randomseed(os.time())
      rand_sob_hey = math.random(0, 3)
      if rand_sob_hey == 0 then
        privet = '������� ������� �����'
      elseif rand_sob_hey == 1 then
        privet = '������������'
      elseif rand_sob_hey == 2 then
        privet = '�����������'
      elseif rand_sob_hey == 3 and os.date('%H') >='06' and os.date('%H') < '12' then
        privet = '������ ����'
      elseif rand_sob_hey == 3 and os.date('%H') >='12' and os.date('%H') < '18' then
        privet = '������ ����'
      elseif rand_sob_hey == 3 and os.date('%H') >='18' and os.date('%H') < '00' then
        privet = '������ �����'
      elseif rand_sob_hey == 3 and os.date('%H') >='00' and os.date('%H') < '06' then
        privet = '������ ����'
      end
    end
    if loading == 'true' and sampIsLocalPlayerSpawned() == true then
      wait(500)
      sampSendChat('/mn') require('samp.events').onShowDialog = function(dialogId, style, dialogTitle, button1, button2, text)
        if dialogId == 487 and sobes ~= 100 then
          lvl = text:match('���������� � ������ .���.:%s{00e673}(%d+)')
          local zakonoposl = string.match(text, '�����������������:%s+{80aaff}(%d+)')
          if tonumber(lvl) < 4 then
            sampAddChatMessage(tg..' ������� �� ��������. ����������� ���: 4 | � ����: '..lvl,main_color)
            sobes = 7
          elseif tonumber(lvl) >= 4 and tonumber(zakonoposl) < 35 then
            sampAddChatMessage(tg..' ������� �� ��������. ���������� �����������������: 35 | � ����: '..zakonoposl,main_color)
            sobes = 5
          else
            sampAddChatMessage(tg..' � ����������� �� � �������. ��� � ���������: '..lvl..' | �����������������: '..zakonoposl,main_color)
          end
        end
        if dialogId == 176 then
          roletime = 'true'
        end
        if dialogId == 63 then
          online1 = string.match(dialogTitle, '������ (%d+)')--find
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
          number = text:match('����� ��������:%s+(.+)\n�� �����')
          sex = text:match('���:%s+(.......)')
          org = text:match('�����������:%s+(.+)\n�������������')
          podrazd = text:match('�������������:%s+(.+)\n������')
          rankname = text:match('���������:%s+(.+)\n����:')
          rank = text:match('����:%s+(.+)\n%s+����������')
          if podrazd == '����� ���-�������' then
            mainIni.config.podrazd_name = 'LS'
            mainIni.config.podrazd = '����� ���-������'
        elseif podrazd == '����� ���-���������' then
          mainIni.config.podrazd_name = 'LV'
          mainIni.config.podrazd = '����� ���-��������'
        elseif podrazd == '����� ���-������' then
          mainIni.config.podrazd_name = 'SF'
          mainIni.config.podrazd = '����� ���-������'
        elseif podrazd == '������������� ����������' then
          mainIni.config.podrazd_name = '��'
          mainIni.config.podrazd = '������������� ����������'
          end
          mainIni.config.phone_number = number
          mainIni.config.sex = sex
          mainIni.config.rank = rank
          mainIni.config.nick = nickname
          mainIni.config.name, mainIni.config.surname = string.match(nickname, '(.+)_(.+)')
          mainIni.config.rankname = rankname
          if mainIni.config.sex == '�������' then
            feminism = '�'
          else
            feminism = ''
          end
          inicfg.save(mainIni, directIni)
          return false
        end
      end
      if ip ~= '54.37.142.74' then
        sampAddChatMessage(tg..' ������ ������������ ������ ��� Advance RP Blue',main_color) crashaa = true
      elseif org == nil then loading = 'true'
      elseif org ~= '�������������' and org == ".+" then
        sampAddChatMessage(tg..' �� �� ��������� ����������� �������������, ������ ������� ����������.',main_color) crashaa = true
      else
        loading = 'false'
        math.randomseed(os.time())
        rand_hey = math.random(1, 2)
        if rand_hey == 1 then
          sampAddChatMessage(tg..' ������, '..rankname..' '..name..' '..surname..', ������ ������� ��������!',main_color)
        elseif rand_hey == 2 and os.date('%H') >='06' and os.date('%H') < '12' then
          sampAddChatMessage(tg..' ������ ����, '..rankname..' '..name..' '..surname..', ������ ������� ��������!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='12' and os.date('%H') <'18' then
          sampAddChatMessage(tg..' ������ ����, '..rankname..' '..name..' '..surname..', ������ ������� ��������!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='18' and os.date('%H') < '00' then
          sampAddChatMessage(tg..' ������ �����, '..rankname..' '..name..' '..surname..', ������ ������� ��������!',main_color)
        elseif rand_hey == 2  and os.date('%H') >='00' and os.date('%H') < '06' then

          sampAddChatMessage(tg..' ������ ����, '..rankname..' '..name..' '..surname..', ������ ������� ��������!',main_color)
          end
          wait(1000)
          imgui_loading.v = false
          imgui_obnova.v = false
          imgui_obnova_test.v = false
          style = 'normal'
        sampAddChatMessage(tg..' ��� ����, ����� ������� �������� ���� �������, ����� /gov.',main_color)
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
      sampSendChat(privet..', � '..mainIni.config.rankname..' '..mainIni.config.name..' '..mainIni.config.surname..', �� �� �����������?')
      sobes = 0
    elseif sobes == 2 then
      math.randomseed(os.time())
      rand_sob_pred = math.random(1, 3)
      if rand_sob_pred == 1 then
        sampSendChat('������, ������������� ����������. ��� ��� �����? ������� ��� ���? ��� ����������?')
      elseif rand_sob_pred == 2 then
        sampSendChat('�������������, ����������. ������� ��� ���, ��� ���������� � ��� �����?')
      elseif rand_sob_pred == 3 then
        sampSendChat('�� �� ������! �������������, ����������. ������� ��� ���, ��� ����� � ��� ����������?')
    end
      sobes = 0
    elseif sobes == 3 then
      math.randomseed(os.time())
      rand_sob_IC = math.random(1, 5)
      if rand_sob_IC == 1 then
        sampSendChat('��� � ���� � ����?')
      elseif rand_sob_IC == 2 then
        sampSendChat('��� � ���� ��� �������?')
      elseif rand_sob_IC == 3 then
        sampSendChat('� ��� ���� Skype?')
      elseif rand_sob_IC == 4 then
        sampSendChat('� ��� ���� ���������?')
      elseif rand_sob_IC == 5 then
        sampSendChat('�� ������� �����-��?')
      end
      sobes = 0
    elseif sobes == 4 then
        sobes = 0
      math.randomseed(os.time())
      rand_sob_dok = math.random(1, 3)
      if rand_sob_dok == 1 then
      sampSendChat('������, � ��� ���� � ����� ���������? ���� ����������..')
      wait(500)
      sampSendChat('..����� �������� � ��� �������!')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' � ������ ������ ���� 4 �������, 35+ �����������������, ������� ����� � �������� �� ������.',main_color)
    elseif rand_sob_dok == 2 then
      sampSendChat('��, ������ ��� ����� ��������� ���� ���������!')
      wait(500)
      sampSendChat('� ������ ������� � ����� ��������')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' � ������ ������ ���� 4 �������, 35+ �����������������, ������� ����� � �������� �� ������.',main_color)
    elseif rand_sob_dok == 3 then
      sampSendChat('����� ����� ��������� ���� ���������.')
      wait(500)
      sampSendChat('��� ����� ���� �������� � �������.')
      wait(500)
      sampSendChat('/n /lic '..id..' /pass '..id)
      wait(50)
      sampAddChatMessage(tg..' � ������ ������ ���� 4 �������, 35+ �����������������, ������� ����� � �������� �� ������.',main_color)
    end
  elseif sobes == 5 then
      sampSendChat('/me ������'..feminism..' ��� � ������� � ���� ������ ���')
      wait(700)
      sampSendChat('/me ����'..feminism..' ���������� �� ������� ��������')
      wait(700)
      sampSendChat('/do �������..')
      wait(1200)
      sampSendChat('/do ������� ����� �������� � �������.')
      wait(700)
      sampSendChat('��������, �� �� ��� �� ���������. �� �� ��������������.')
      wait(700)
      sampSendChat('/n ��� ���������� � ����������� � ��� �� ������ ���� ������� � 35+ �������.')
      sobes = 100
    elseif sobes == 6  then
      sampSendChat('����������! �� ������ ������������� � ��� ���������.')
      sobes = 100
      if tonumber(mainIni.config.rank) < 9 then
        sampSetChatInputText('/r ������� � ** ������ �������������. ����� ������ ����� � �����!')
        sampSetChatInputEnabled(true)
      end
    elseif sobes == 7 then
      sampSendChat('��������, �� ��� �� ���������.')
      wait(700)
      sampSendChat('��� ��������������� � �������������, �� ������ ��� ������� ���������..')
      wait(700)
      sampSendChat('..4 ���� � ���������. ��������� �����!')
      sobes = 100
    elseif sobes == 8 then
      sampSendChat('/me ����������� ����������'..feminism..' ������� �������� ��������')
      wait(700)
      sampSendChat('��������, �� �� ����� ������� ��� ��� ��� � ����� �������� ������.')
      wait(700)
      sampSendChat('/n ��� ������ ���� ������� Nick_Name � ��������� ���������� �����/�������')
      sobes = 100
    elseif sobes == 9 then
      sobes = 100
      sampSendChat('����� ��������, �� �� ��� �� ���������.')
      wait(700)
      sampSendChat('� ��� ��� ����������� ��������.')
      wait(700)
      sampSendChat('/n � ��� ������ ���� ������� �������� �� �������� � �������� �� ������.')
    elseif sobes == 10 and rank < '9' then sampAddChatMessage(tg..' ������� �������� � 9 �����.',main_color)
      sobes = 100
    elseif sobes == 10 and tonumber(rank) >= 9 then
        sampSendChat('/me ������'..feminism..' ���� � �������, ������'..feminism..' ����� ������� �������')
         wait(500)
         sampSendChat('/me �������'..feminism..' ����� �� ���� � ������'..feminism..' � ������� ��������� �����, ������'..feminism..' ����')
         wait(700)
         sampSendChat('/me �������'..feminism..' ����� �� ����� � ������ � ����'..feminism..' � ����')
         wait(1500)
         sampSendChat('/me �������'..feminism..' ����� � ������ �������� ��������')
         sampAddChatMessage(tg..' ������� ID ������.',main_color)
         sampSetChatInputText('/invite ')
         sampSetChatInputEnabled(true)
      sobes = 100
    elseif sobes == 10 and tonumber(rank) >= 9 then
      sobes = 100
      sampSendChat('/me ������ ���� � �������, ������ ����� ������� �������')
       wait(500)
       sampSendChat('/me �������'..feminism..' ����� �� ���� � ������ � ������� ��������� �����, ������'..feminism..' ����')
       wait(700)
       sampSendChat('/me �������'..feminism..' ����� �� ����� � ������ � ����'..feminism..' � ����')
       wait(1500)
       sampSendChat('/me �������'..feminism..' ����� � ������ �������� ��������')
       sampSetChatInputText('/invite '..idhh)
     elseif sobes == 11 then
       sobes = 100
     sampSendChat('��������, �� �� ��� �� ���������. �� �������!')
     wait(1000)
     sampSendChat('/n ��������� � ��������� ��� ����� RP, IC, MG, OOC, ����� ������������� �� �������������.')
    end
    if roletime == 'true' and mainIni.settings.rptime == true then
      sampSendChat('/me ���������'..feminism..' �� ���� ����� Breitling Avi 1953 Limited Edition Platinum')
      wait(300)
      sampSendChat('/do ������ �����: '..os.date('%H')..':'..os.date('%M')..':'..os.date('%S'))
        roletime = 'false'
    end
    if find == 'true' and mainIni.settings.rpfind == true and tonumber(online1) <= 20 then
      sampSendChat('/me ������'..feminism..' ��� � �������')
      wait(200)
      sampSendChat('/me ������� �� ������� ������� �����������')
      wait(200)
      sampSendChat('/do ���������� ����������� � ���������: '..online1)
      find = 'false'
    elseif find == 'true' and mainIni.settings.rpfind == true and tonumber(online1) > 20 and knopka2 == '���.2 >>' then
      sampSendChat('/me ������'..feminism..' ��� � �������')
      wait(200)
      sampSendChat('/me ������� �� ������� ������� �����������')
      wait(200)
      sampSendChat('/do ���������� ����������� � ���������: '..online1)
      find = 'false'
    end

    if freedom == 1 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' �� �������� ���������� ��������� �� ���.',main_color) freedom = 'start'
    elseif freedom == 1 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
        wait(700)
        sampSendChat('������, ������� ����������, �� ���?')
        wait(700)
        sampSendChat('/n ���� ��� �������� ������ ��� ���, �������� ��� �� ������ ����������.')
        sampAddChatMessage(tg..' ������� ������� "J", ����� ���������� ��� "K", ����� ��������.',main_color)
        freedom = 2
    elseif freedom == 2 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' �� �������� ���������� ��������� �� ���.',main_color)
      freedom = 'start'
    elseif freedom == 2 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
      sampSendChat('� ����� ������ � ���� ��� ���������, ������ ���������� ��� ���������.')
      wait(850)
      sampSendChat('/do � ����� ���� � ����������� �������������.')
      wait(850)
      sampSendChat('/me ������'..feminism..' ���� � ������'..feminism..' ������ ������, ������'..feminism..' ���� � �������'..feminism..' ������ �� ����')
      wait(850)
      sampSendChat('/me �����'..feminism..' ���������� ���������� �� ��� �� ��� '..rpnamefree..' '..rpsurnamefree)
      wait(850)
      sampSendChat('/todo ������ ������� �� ����� ��� �������*��� ���������� ���� ������� ����� � �����.')
      wait(850)
      sampSendChat('/me �������'..feminism..' ����� �������� ��������')
      wait(1000)
      sampSendChat('/n /me ����������(���)')
      sampAddChatMessage(tg.. ' ������� "J" ��� ������������ ��� "K" ��� ������.',main_color)
      freedom = 3
    elseif freedom == 3 and sampIsChatInputActive() == false and isKeyJustPressed(VK_K) then
      sampAddChatMessage(tg..' �� �������� ���������� ��������� �� ���.',main_color)
      sampSendChat('/me ������ ��� ��������� ������� � ����') freedom = 'start'
    elseif freedom == 3 and sampIsChatInputActive() == false and isKeyJustPressed(VK_J) then
      sampSendChat('��������� ������� ���������, ������ �������� ������ �� ���.')
      wait(850)
      sampSendChat('/me ���'..feminism..' ������� � ���� '..rpnamefree)
      wait(850)
      sampSendChat('/do ���������� �� �������: '..mainIni.config.podrazd_name..' | '..mainIni.config.name..' '..mainIni.config.surname..' | '..mainIni.config.rankname)
      wait(850)
      sampSendChat('/free '..freeid..' 9000')
      sampAddChatMessage(tg..' ���� �������� ������� ���������, ������� "H", � ��������� ������ - "R".',main_color)
      freedom = 4
    elseif freedom == 4 and sampIsChatInputActive() == false and isKeyJustPressed(VK_R) then
      sampSendChat('��������, ��� ��������� ����������, ��� � �� ���� ��� ���������.')
      wait(500)
      sampSendChat('/me ������ ��� ��������� ������� � ����')
      wait(500)
      sampSendChat('/n ��� �������� ������, ���, ��� ���, � ��� ������������ ����� ��� �� ������ �������')
      freedom = 'start'
    elseif freedom == 4 and sampIsChatInputActive() == false and isKeyJustPressed(VK_H) then
      sampAddChatMessage(tg..' �� ������� ���������� ������ '..rpnamefree..' '..rpsurnamefree,main_color)
      freedom = 'start'
    end
    if checkf == 'OOP' then
      checkf = nil
      lua_thread.create(function()
      sampSendChat('/do �� ��� ��������� ����������.')
        wait(1000)
      sampSendChat('/do '..string.match(sampGetPlayerNickname(idf), '(.+)_(.+)')..' ����� ������� ����������.')
        wait(800)
        sampSendChat('��������, �� ������ � �� � ����� ����������� �������� �� ��� ��� ���.')
        wait(800)
        sampSendChat('/me ������� ���')
      end)
    elseif checkf == 'NeOOP' then
      checkf = nil
      lua_thread.create(function()
        sampSendChat('/do �� ��� ��������� ����������.')
          wait(1000)
          sampSendChat('/do '..string.match(sampGetPlayerNickname(idf), '(.+)_(.+)')..' �� �������� ���.')
            wait(700)
            sampSendChat('�� � �������, ������� ������ ���������� ���������� �� ���?')
            wait(700)
            sampSendChat('��� ����� ������ �� 9.000$, ���� �� �� �������� � ��������������� ����������� � 10.000$, ���� ��������.')
      end)
    end
    if mainIni.settings.quickaction == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_B) then
      if getCharPlayerIsTargeting(playerHandle) == false then sampAddChatMessage(tg..' �������� �� ������, ������� ���+Alt+B ��� ��������� Quick action.',main_color)
      elseif getCharPlayerIsTargeting(playerHandle) == true and tonumber(rank) == 5 then
        local result_1, target_1 = getCharPlayerIsTargeting(playerHandle)
        if result_1 then result_1, targetid_1 = sampGetPlayerIdByCharHandle(target_1) end
      sampAddChatMessage(tg..' ����������� Quick Release �� ������ '..sampGetPlayerNickname(targetid_1),main_color)
      sampSendChat('/free '..targetid_1..' 9000')
      UDOname, UDOsurname = string.match(sampGetPlayerNickname(targetid_1), '(.+)_(.+)')
      lua_thread.create(function()
        wait(500)
      sampSendChat('/do � ����� ���� � �������������.')
      wait(800)
      sampSendChat('/me ������'..feminism..' ���� � ������'..feminism..' ����������� ��������� �� ���')
      wait(800)
      sampSendChat('/me �������'..feminism..' ��� �� ��� '..UDOname..' '..UDOsurname)
      wait(800)
      sampSendChat('/me �������'..feminism..' ��������� ������� � ���� � ������ ���')
      wait(800)
      sampSendChat('/me �������'..feminism..' ������� '..UDOname)
      wait(800)
      sampSendChat('/do ������� �� �������: '..mainIni.config.name..' '..mainIni.config.surname..' | '..mainIni.config.podrazd_name..' | '..mainIni.config.phone_number)
    end)
  elseif getCharPlayerIsTargeting(playerHandle) == true and tonumber(rank) == 6 then
        local result_1, target_1 = getCharPlayerIsTargeting(playerHandle)
        if result_1 then result_1, targetid_1 = sampGetPlayerIdByCharHandle(target_1) end
        sampAddChatMessage(tg..' ����������� Quick Sell License �� ������ '..sampGetPlayerNickname(targetid_1),main_color)
        sampAddChatMessage(tg..' ������� ��� �������� � ��������� � � ����.',main_color)
        lua_thread.create(function()
          local actname, actsurname = string.match(sampGetPlayerNickname(targetid_1), '(.+)_(.+)')
          sampSetChatInputText('/givelic '..targetid_1..' ')
          sampSetChatInputEnabled(true)
          sampSendChat('/do � ����� ���� � ������� �������� �� ������ ���� ��������.')
          wait(1000)
          sampSendChat('/me ������'..feminism..' ���� � ������'..feminism..' ����������� ������')
          wait(1000)
          sampSendChat('/me �������'..feminism..' ������ �� ��� '..actname..' '..actsurname)
          wait(1000)
          sampSendChat('/me �������'..feminism..' �������� � ����')
          wait(1000)
          sampSendChat('/me �������'..feminism..' �������� �������� ��������')
          wait(1000)
          sampSendChat('�� �� ������� �������� ��������� ����� �� ��������� �������?')
        end)
        end
    end
    if briefing_SB == true then
      lua_thread.create(function()
      briefing_SB = false
      sampSendChat('���, ������ ��� ���������� �������� ���� ����-������...')
      wait(800)
      sampSendChat('�� ������ ����� ������������ �� ��������� ��.')
      wait(800)
      sampSendChat('������ �����, �� ������ ����� ���������� � ������ ��� ����, �����...')
      wait(800)
      sampSendChat('..���������� � �����. �� ������� � ���� �������� � ������� � ������� ������')
      wait(800)
      sampSendChat('/n /armoff /drop')
      wait(800)
      sampSendChat('����� ������ �� ������ ��������� ������ � ����� ������ �������, ����� � ����...')
      wait(800)
      sampSendChat('..��� � ������ ����������� ����� ���� ������ �����. ����� ��������� ������ ��������������.')
      wait(800)
      sampSendChat('��� ������� ��������������� ���� �������, ��� �������������� ����� ������ ����.')
      wait(800)
      sampSendChat('�� ���� ��������� �� ������ ������������ ����� �� ������� �����')
      wait(800)
      sampSendChat('/n https://forum.advance.rp/ru - Blue server - ����������� - ������������� - F.A.Q.')
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
  if text:find('�� ���������: {00CC33}������� �������') and sobes ~= 100 or text:find('�� ���������: {6699CC}���������������� �������') and sobes ~= 100 then
    lic = 0 + 1
  elseif text:find('�� ������:     {00CC33}����') and sobes ~= 100 then
    lic = lic + 1
    proverkalic = true
  end
  if text:find('���� ����� �� � ������') and checkall == true then return false
  elseif text:find('������ � ����� id ���') and checkall == true then return false
  elseif text:find('���� ������� - ������� ����������. �� �� ����� ���� ��������� ��������') and checkall == true then return false
  end
  if checkf == 'true' and text == '���� ������� - ������� ����������. �� �� ����� ���� ��������� ��������' then
    sampAddChatMessage(tg..' ���� ������� ���, ��������� ������ ��������...',main_color)
    checkf = 'OOP'
  elseif checkf == 'true' and text == '�� ���������� '..sampGetPlayerNickname(idf)..' ����� �� ������� �� {FF6633}.+' then
      sampAddChatMessage(tg..' ���� ������� �� ��� � � ���� ���������� �����, ����� ���������� ��� �� ������ ������� /fre '..idf)
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
    if imgui.Button(fa.ICON_INFO..u8' ����������',btnSize) then menu_selected = 10 end
    if imgui.Button(fa.ICON_QUESTION_CIRCLE_O..u8' ������', btnSize) then menu_selected = 1 end
    if imgui.Button(fa.ICON_USER_PLUS..u8' �������������',btnSize) then menu_selected = 3 end
    if imgui.Button(fa.ICON_BULLHORN..u8' ��� �������',btnSize) then
      imgui_help.v = false
      imgui_gnews.v = true
    end
    if imgui.Button(fa.ICON_WINDOW_MAXIMIZE..u8' ������� ����', btnSize) then
      imgui_help.v = false
      imgui_mainmenu.v = true
    end
      if imgui.Button(fa.ICON_COG..u8' ���������', btnSize) then menu_selected = 2 end
      if texture_cat ~= nil then imgui.Image(texture_cat, texture_zoom) end
    imgui.EndChild()
    imgui.SameLine()
    if menu_selected == 10 then --����������--
      imgui.BeginChild('textmmenu', cmd_a, true)
      imgui.TextColoredRGB(themecolor..u8'Government Helper by samartinell\n '..themecolor..fa.ICON_PAW..u8' ������, {FFA500}'..mainIni.config.name..' '..mainIni.config.surname..u8''..themecolor..u8', ��� ����� ������������ ���\n '..themecolor..u8' �������� � ����� ������:\n\n-'..themecolor..u8' ��������� �������� ���� ��� ���� ������ � �����������\n '..themecolor..u8'�������\n-'..themecolor..u8' ���������� ImGui ����������')
      imgui.TextColoredRGB('-'..themecolor..u8' ��������� ������ ������������� � ������� � ����� �������\n-'..themecolor..u8' ��������� ���. ����� ��� �������(beta)\n-'..themecolor..u8' ���������� ����\n\t\t\t\t\t\t\t\t\t\t\t\t\t������ �������: '..script_version)
      imgui.EndChild()
    elseif menu_selected == 1 then
      imgui.BeginChild('helpmenu', cmd_a,true)
      imgui.TextColoredRGB(u8'\t\t\t\t\t\t\t\t������� �������:\n\n/gov '..themecolor..u8' - �������� ����.\n/qq '..themecolor..u8'- ������������������\n/rr'..themecolor..u8' - OOC ��������� � ����� /r\n/ff'..themecolor..u8' - OOC ��������� � ����� /f\n/fre ID '..themecolor..u8' - ���������� � ���������� ��������(��� ���������)\n/hh ID (��� ���+R) '..themecolor..u8' - �������������� � �������.\n/mm'..themecolor..u8' - ������� ����(��� ������ ����������)\n/gos'..themecolor..u8' - ��� ������� ')
      imgui.TextColoredRGB(u8'/leakmenu'..themecolor..u8' - ���� ������� ����������\n\n\n'..themecolor..u8'����� � �������������:\n'..fa.ICON_ENVELOPE..u8' samartinell@gmail.com')
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
      if setting_1 == true and imgui.RadioButton(u8"RP /find(���)", setting_1) then setting_1 = false mainIni.settings.rpfind = setting_1 inicfg.save(mainIni, directIni) elseif setting_1 == false and imgui.RadioButton(u8"RP /find(����)", setting_1) then setting_1 = true mainIni.settings.rpfind = setting_1 inicfg.save(mainIni, directIni)
      elseif setting_2 == true and imgui.RadioButton(u8"RP /c 60(���)", setting_2) then setting_2 = false mainIni.settings.rptime = setting_2 inicfg.save(mainIni, directIni) elseif setting_2 == false and imgui.RadioButton(u8"RP /c 60(����)", setting_2) then setting_2 = true mainIni.settings.rptime = setting_2 inicfg.save(mainIni, directIni)
      elseif setting_3 == true and imgui.RadioButton(u8"RP �����(���)", setting_3) then setting_3 = false mainIni.settings.rpradio = setting_3 inicfg.save(mainIni, directIni) elseif setting_3 == false and imgui.RadioButton(u8"RP �����(����)", setting_3) then setting_3 = true mainIni.settings.rpradio = setting_3 inicfg.save(mainIni, directIni)
      elseif setting_4 == true and imgui.RadioButton(u8"Quick action(���)", setting_4) then setting_4 = false mainIni.settings.quickaction = setting_4 inicfg.save(mainIni, directIni) elseif setting_4 == false and imgui.RadioButton(u8"Quick action(����)", setting_4) then setting_4 = true mainIni.settings.quickaction = setting_4 inicfg.save(mainIni, directIni)
      elseif setting_5 == true and imgui.RadioButton(u8"Ҹ���� ����(���)", setting_5) then setting_5 = false mainIni.settings.darktheme = setting_5 inicfg.save(mainIni, directIni) sampAddChatMessage(tg..' �� ��������� �� ������� �������!',main_color) sampAddChatMessage(tg..' ��������� ����� ���������� ����� ������������ �������.',main_color) elseif setting_5 == false and imgui.RadioButton(u8"Ҹ���� ����(����)", setting_5) then setting_5 = true mainIni.settings.darktheme = setting_5 inicfg.save(mainIni, directIni) sampAddChatMessage(tg..' �� ������� �� ����� �������.',main_color)  sampAddChatMessage(tg..' ��������� ����� ���������� ����� ������������ �������.',main_color)
      end
      imgui.Text('\n\n\n')
      if imgui.Button(fa.ICON_REFRESH..u8'������������� ������', imgui.ImVec2(191, 0)) then  lua_thread.create(function() imgui_help.v = false wait(100) thisScript():reload() end) end
      imgui.SameLine()
      if imgui.Button(fa.ICON_POWER_OFF..u8'��������� ������',imgui.ImVec2(191, 0)) then lua_thread.create(function() imgui_help.v = false wait(100) crashaa = true end) end
      imgui.EndChild()
    elseif menu_selected == 3 then
      --sobes
      imgui.BeginChild('commandmenu', cmd_a,true)
      if imgui.Button(u8'\t�����������', buttonSize) then sobes = 1 end
      if imgui.Button(u8'��������� �������������', buttonSize) then sobes = 2 end
      if imgui.Button(u8'IC ������',buttonSize) then sobes = 3 end
      if imgui.Button(u8'���������',buttonSize) then sobes = 4 end
      if imgui.Button(u8'��������',buttonSize) then sobes = 6 end
      if imgui.Button(u8'�������� ����������',buttonSize) then briefing_SB = true end
      if imgui.Button(u8'������� � �����������',buttonSize)  then sobes = 10 end
      if imgui.CollapsingHeader(u8'�� ��������',buttonSize) then --sobes = 5 end
      if imgui.Button(u8'������',buttonSize) then sobes = 11 end
      if imgui.Button(u8'�������� � �������',buttonSize) then sobes = 5 end
      if imgui.Button(u8'���� ��� � �����',buttonSize) then sobes = 7 end
      if imgui.Button(u8'������ � �����',buttonSize) then sobes = 8 end
      if imgui.Button(u8'��� ��������',buttonSize) then sobes = 9 end
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
    imgui.Begin(u8'�������������� � �������: '..nickhh..'['..idhh..']',interaction_window,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local button_1 = imgui.Button(u8'�������������� ��� ��. �������.',btnsizeint)
    local button_2 = imgui.Button(u8'�������������� � �����������(������ ��� ���������)',btnsizeint)
    local button_3 = imgui.Button(u8'�������������� ��� ���������',btnsizeint)
    local button_4 = imgui.Button(u8'�������������� ��� ��',btnsizeint)
    if button_4 then interaction_window.v = false imgui_SB.v = true end
    if button_1 and tonumber(rank) >= 5 then -- ������� ��� 8+ ������
      interaction_window.v = false
      imgui_st_sost.v = true
    elseif button_1 and tonumber(rank) <5 then --������� ��� 8+ ������
      sampAddChatMessage(tg..' ������ ������������ ��� 8+ �����.', main_color)
    end
    if button_2 and tonumber(rank) == 5 then
      interaction_window.v = false
      imgui_lawyer.v = true
    elseif button_2 and tonumber(rank) ~= 5 then
      sampAddChatMessage(tg..' ������� �������� ������ ���������.',main_color)
    end
  if button_3 and tonumber(rank) >=6 and tonumber(rank) <= 7 then -- ���������� 6 � 7 ����
    interaction_window.v = false
    imgui_licensor.v = true
  elseif button_3 and tonumber(rank) < 6 or button_3 and tonumber(rank) >7 then--���������� 6 � 7 ����
    sampAddChatMessage(tg..' ������� �������� ������ ���������.',main_color)
  end
    imgui.End()
  end

if imgui_leakmenu.v then
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.Always)
  imgui.Begin(u8'��������� ����������.', imgui_leakmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
  if imgui.Button(u8'�������������',imgui.ImVec2(350, 0)) then
        lua_thread.create(function()
          sampSendChat(privet..', ���� ����� '..mainIni.config.name..' '..mainIni.config.surname..'.')
          wait(1000)
          sampSendChat('�� �� ������� ��������� ����������?')
        end)
  end
  if imgui.Button(u8'��������� ���������',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('������, ����� ��� ����� ����� �� ����� �������� �� ����������..')
    wait(1000)
    sampSendChat('..� � ���� ������� ���� ���������.')
    wait(1000)
    sampSendChat('/n �������� ����� ���� �� ������ ������ ������, �������, ��������� � �� + /pass '..id)
  end)
  end
  if imgui.Button(u8'��������� ��������',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('/me ������'..feminism..' ��� � ������� �������')
    wait(1000)
    sampSendChat('/me ������'..feminism..' ���� �������������')
    wait(1000)
    sampSendChat('/me ������������� ����� "��������"')
    wait(1000)
    sampSendChat('/do �������...')
      wait(4000)
    sampSendChat('/do �������� �������������.')
    end)
  end
  if imgui.Button(u8'������� ���� � ����������� ������ ������',imgui.ImVec2(350, 0)) then
    lua_thread.create(function()
    sampSendChat('/do � ����� ���� � ������� ��������.')
      wait(1000)
      sampSendChat('/me ������'..feminism..' ���� � ������'..feminism..' ��� ����������� ���������')
      wait(1000)
      sampSendChat('/me ����'..feminism..' ����� � ��������'..feminism..' �������')
  end)
  end
  if imgui.Button(u8'�������� ������ ������',imgui.ImVec2(350, 0)) then
    if leakmenu_buffer_id.v == '' or sampIsPlayerConnected(leakmenu_buffer_id.v) == false then
    sampAddChatMessage(tg..' ������� ������� ID!',main_color)
  else
    lua_thread.create(function()
      sampSendChat('/me �������'..feminism..' ������ ������ � ���� '..sampGetPlayerNickname(leakmenu_buffer_id.v):match('(.+)_')..' '..sampGetPlayerNickname(leakmenu_buffer_id.v):match('_(.+)'))
      wait(1000)
      sampSendChat('/leak '..leakmenu_buffer_id.v..' 15000')
      wait(1000)
      sampSendChat('/me ������'..feminism..' ����.')
      sampSendChat('/c 060')
    end)
  end
  end
  local inputid = imgui.InputText(u8'ID ������', leakmenu_buffer_id)
  imgui.End()
end

if imgui_obnova.v then
  imgui.ShowCursor = false
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(130, 20), imgui.Cond.Always)
  imgui.Begin(u8'��� ��������..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
  imgui.Text(u8'��� ����������...')
  imgui.End()
end


if imgui_obnova_test.v then
  imgui.ShowCursor = false
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(150, 20), imgui.Cond.Always)
  imgui.Begin(u8'��� ��������..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
  imgui.Text(u8'�������� ����������...')
  imgui.End()
end


  if imgui_loading.v then
    imgui.ShowCursor = false
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 50, imgui.GetIO().DisplaySize.y / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(120, 20), imgui.Cond.Always)
    imgui.Begin(u8'��� ��������..', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
    imgui.Text(u8'��� ��������...')
    imgui.End()
  end
if imgui_SB.v then
  local btnSizeSb = imgui.ImVec2(350,0)
  imgui.ShowCursor = true
  imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
  imgui.SetNextWindowSize(imgui.ImVec2(350, 300), imgui.Cond.Always)
  imgui.Begin(u8'�������������� � �������: '..nickhh..'['..idhh..']',imgui_SB, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
  if imgui.Button(u8'�������� ����',btnSizeSb) then
    sampAddChatMessage(tg..' ������� � ����������',main_color)
  end
  if imgui.Button(u8'������������ �������',btnSizeSb) then
    sampAddChatMessage(tg..' ������� � ����������',main_color)
  end
  imgui.End()
end
  if imgui_st_sost.v then
    local btnsizesost = imgui.ImVec2(350,0)
    imgui.ShowCursor = true
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(350, 300), imgui.Cond.Always)
    imgui.Begin(u8'�������������� � �������: '..nickhh..'['..idhh..']',imgui_st_sost,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local namehh, surnamehh = nickhh:match('(.+)_(.+)')
    if imgui.Button(u8'������� � �����������',btnsizesost) then
      if tonumber(rank) <9 then
        sampAddChatMessage(tg..' ������� � ����������� ����� � ��������� ����������� ����[9]',main_color)
      elseif tonumber(rank) >= 9 and mainIni.config.sex == '�������' then
        lua_thread.create(function()
        sampSendChat('/do �� ����� ����� ������ ������������ ������� ����.')
        wait(800)
        sampSendChat('/me ������� ���� ����� ������������ �����')
        wait(800)
        sampSendChat('/me �������� ����� �� ����� � ������')
        wait(800)
        sampSendChat('/me �������� ����� � ����� �������� ��������')
        wait(800)
        sampSendChat('/invite '..idhh)
        wait(800)
        sampSendChat('/r �������������� ������ ���������� - '..namehh..' '..surnamehh..'!')
      end)
      else
        lua_thread.create(function()
            sampSendChat('/do �� ����� ����� ������ ������������ ������� ����.')
            wait(800)
            sampSendChat('/me ������ ���� ����� ������������ �����')
            wait(800)
            sampSendChat('/me ������� ����� �� ����� � ������')
            wait(800)
            sampSendChat('/me ������� ����� � ����� �������� ��������')
            wait(800)
            sampSendChat('/invite '..idhh)
            wait(800)
            sampSendChat('/r �������������� ������ ���������� - '..namehh..' '..surnamehh..'!')
        end)
    end
  end
    if imgui.Button(u8'������ �����',btnsizesost) then
      if tonumber(rank) < 8 then
        sampAddChatMessage(tg..' ����� ����� �������� ������ � ��������� �������[8]',main_color)
      elseif tonumber(rank) >= 8 and mainIni.config.sex == '�������' then
        lua_thread.create(function()
          sampSendChat('/do � ����� ������������ ����� � ������.')
            wait(800)
          sampSendChat('/me �������� ����� � ���� '..namehh..' '..surnamehh)
          wait(800)
          sampSendChat('/changeskin '..idhh)
          wait(800)
          sampSendChat('���� ����� �� ������� ��� �� �������, �������� �� ����.')
        end)
      else
          lua_thread.create(function()
          sampSendChat('/do � ����� ������������ ����� � ������.')
            wait(800)
          sampSendChat('/me ������� ����� � ���� '..namehh..' '..surnamehh)--��������� ��� ������
          wait(800)
          sampSendChat('/changeskin '..idhh)
          wait(800)
          sampSendChat('���� ����� �� ������� ��� �� �������, �������� �� ����.')
        end)
        end
     end
    if imgui.Button(u8'��������',btnsizesost) then
      if tonumber(rank) < 9 then
        sampAddChatMessage(tg..' ��������/�������� ����� ������ � ��������� ����������� ����.',main_color)
      elseif tonumber(rank) >= 9 and mainIni.config.sex == '�������' then
        lua_thread.create(function()
      sampSendChat('/do � ����� ����� ������� �� ��� '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me �������� ����� ������� �������� ��������')
      wait(800)
      sampSendChat('/rang '..idhh..' +')
      sampSendChat('���������� � ����� ����������!')
      end)
      else
        lua_thread.create(function()
      sampSendChat('/do � ����� ����� ������� �� ��� '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me ������� ����� ������� �������� ��������') --��������� ��� ������
      wait(800)
      sampSendChat('/rang '..idhh..' +')
      sampSendChat('���������� � ����� ����������!')
      end)
    end
  end
    if imgui.Button(u8'��������',btnsizesost) then
      if tonumber(rank) < 9 then
       sampAddChatMessage(tg..' ��������/�������� ����� ������ � ��������� ����������� ����.',main_color)
     elseif tonumber(rank) >= 9 and mainIni.config.sex == '�������' then
       lua_thread.create(function()
     sampSendChat('/do � ����� ����� ������� �� ��� '..namehh..' '..surnamehh..'.')
     wait(800)
     sampSendChat('/me �������� ����� ������� �������� ��������')
     wait(800)
     sampSendChat('/rang '..idhh..' +')
     end)
     else
        lua_thread.create(function()
      sampSendChat('/do � ����� ����� ������� �� ��� '..namehh..' '..surnamehh..'.')
      wait(800)
      sampSendChat('/me ������� ����� ������� �������� ��������')--��������� ��� ������
      wait(800)
      sampSendChat('/rang '..idhh..' -')
      end)
     end
   end
    if imgui.Button(u8'�������',btnsizesost) then
      if tonumber(rank) >= 8 then
        lua_thread.create(function()
          sampSetChatText('/uninv '..idhh..' ')
          sampSetChatInputEnabled(true)
          sampAddChatMessage(tg..' ������� � ��� ������� ����������!',main_color)
        end)
      else sampAddChatMessage(tg..' ��������� ����� ������ � 8 �����!',main_color)
      end
    end
    if imgui.Button(u8'�������� ����������',btnsizesost) then briefing_SB = true end
    if imgui.CollapsingHeader(u8'������ �������') then
      local quest_1 = '���� � 24/7 ������������ ��������� � ������ ����, ������ ����� �������.'
      local quest_2 = '� ��� �� ������ ����� �������� ���� �� ������, ����� ��� ���� � ������.'
      local quest_3 = '� ���������. ���� ��������� �������� ������������� �����, ������ � ��� ����'
      local quest_4 = '� ���������, ������� �� ������� ��������� �� ������ �����, ��������� ����.'
      local quest_5 = '� ��������� �� ������� �� ������ ����� ���� ������� ���������. ���������.'
      local quest_6 = '� ���� ��� ���� ��������� �������! ���� ����������� � ��������..'
      local quest_7 = '����� ����� ������ � � �������� ����� ���������� ���������� �������...'
      local quest_8 = '�������� �����������: ������, �����, ������� � ������� � ���������.'
      local quest_9 = '�� ������ ����� ����� �������� �������� �������, ����� ���� � ��������. ������.'
      imgui.Text(u8'������� ����������� �� ������ ���������, � \n������ �� ��� ������� 3� �������.')
      if imgui.Button(u8'������ �������',btnsizesost) then
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
          sampSendChat('����� �������� ��� ��� �� ����, ���� ����� �� � �������� � ������.')
          end)
        end
      end
      if imgui.Button(u8'������ �������',btnsizesost) then
        lua_thread.create(function()
        math.randomseed(os.time())
        local second_level = math.random(1, 3)
        if second_level == 1 then
          sampSendChat(quest_7)
          wait(7000)
          sampSendChat('..�� ���� ������ ������� ���������� ��� �������� ����� ������, ���������� � ������.')
        elseif second_level == 2 then
          sampSendChat(quest_8)
          wait(1000)
          sampSendChat('/pay '..idhh..' 3000')
        elseif second_level == 3 then
          sampSendChat(quest_3)
        end
      end)
      end
      if imgui.Button(u8'������ �������',btnsizesost) then
        lua_thread.create(function()
        math.randomseed(os.time())
        local third_level = math.random(1, 3)
        if third_level == 1 then
          sampSendChat(quest_6)
          wait(6300)
          sampSendChat('..� ������ ���������� �������� �������� '..mainIni.config.podrazd_name..', ���������� �����..')
          wait(6000)
          sampSendChat('..� ������ �� � ������� � �������� ����. � ������ ������� ��. ������ �����.')
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
    imgui.Begin(u8'�������������� � �������: '..nickhh..'['..idhh..']',imgui_licensor,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    if imgui.Button(u8'�������������',btnsizelic) then
      lua_thread.create(function()
        sampSendChat(privet..', � '..rankname..' - '..mainIni.config.name..' '..mainIni.config.surname..'.')
        wait(500)
        sampSendChat('�� ������ ���������� ��������?')
      end)
    end
    if imgui.Button(u8'���������� � ��������� ����� ��������',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('�� ������ ���������� ����� 2 ���� ��������: ')
        wait(500)
        sampSendChat('���������������� �����, ������� �������� �������� �� ��������� � ������ ���������..')
        wait(800)
        sampSendChat('..� �������� �� ������. ��������� �� 10.000$ � 30.000$ �������������, ������ ���������.')
    end)
    end
    if imgui.Button(u8'��������� ��� � ������� � ���������',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('��� �����, ����� �� ������� ��� ���, �������...')
        wait(500)
        sampSendChat('..� �������� ��� ���� ������� � ������� ��������.')
        wait(800)
        sampSendChat('/n /pass '..id..' /lic '..id)
      end)
    end
    if imgui.Button(u8'������ ����������',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('/do � ����� ���� � ������� �����������.')
          wait(800)
        sampSendChat('/me ������ ���� � ������ ��������� � ������ � ����')
        wait(800)
        sampSendChat('/me ����� ���������� ���������� �� ��� '..nickhh)
        wait(800)
        sampSendChat('/todo ������ �� ���� ��� �������� �������*��� ����� ����� �����������')
        wait(100)
        sampSendChat('/n /me ����������(���)')
      end)
    end
    if imgui.Button(u8'������ ����� �� ��������',btnsizelic) then
      sampAddChatMessage(tg..' �������� ����� �� �������� ��������� ������� ���������.',main_color)
    end
    if imgui.Button(u8'������ ���������������� �����',btnsizelic) then
      sampSendChat('/givelic '..idhh..' 1 10000')
    end
    if imgui.Button(u8'������ ����� �� ������',btnsizelic) then
      lua_thread.create(function()
      sampSendChat('/givelic '..idhh..' 2 30000')
      if msgmm:find('� ���������� ��� ���� ������ ��� ��������') then
        sampAddChatMessage(tg..' � ������ ���� ��� ���� ��� ��������', main_color)
        sampSendChat('�� �� ���������� � ������ ���� ��������, �� ��� �������� ��.')
        wait(1000)
        sampSendChat('/me ��������� ������, ������� �� � ����������� ���������...')
        wait(1000)
        sampSendChat('/me ..� ������ ����')
      elseif msgmm:find('� ���������� ��� ����� �����') then
        sampAddChatMessage(tg..' � ������ ��� ������� �����',main_color)
        sampSendChat('� ���������, � �� ���� �������� �� ��� ��� ��������.')
        wait(1000)
        sampSendChat('� ��� ������������ �����. �������������, ����� ����� 30.000$')
        wait(1000)
        sampSendChat('/me ��������� ������, ������� �� � ����������� ���������...')
        wait(1000)
        sampSendChat('/me ..� ������ ����')
      else sampSendChat('/me ������� �������� ������ � ������ � ���� � ������ ���')
      end
    end)
    end
    if imgui.Button(fa.ICON_ID_CARD_O..u8' ������ �������',btnsizelic) then
      lua_thread.create(function()
        sampSendChat('�������, ��� ������� ���� � �������� ��������.')
        wait(800)
        sampSendChat('������ ���������� �� ��� ��� ������������� ���� ����� ��������.')
        wait(800)
        sampSendChat('/me �������'..feminism..' ������� �������')
        wait(800)
        sampSendChat('/do ������� �� �������: '..rankname..' | '..mainIni.config.phone_number..' | '..mainIni.config.podrazd_name..'.')
          promo_1 = string.match(mainIni.config.name,'(.)')
          wait(800)
        sampSendChat('�� ��������� #'..mainIni.config.phone_number..promo_1..mainIni.config.podrazd_name..' �� �������� ������ 20 ���������!')
      end)
    end
    imgui.End()
  end

  if imgui_lawyer.v then
    imgui.ShowCursor = true
    local btnsizelawyer = imgui.ImVec2(400,0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 450), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'�������������� � �������: '..nickhh..'['..idhh..']',imgui_lawyer,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    local butlawyer_0 = imgui.Button(u8'��������� �������� �� ���',btnsizelawyer)
    local butlawyer_1 = imgui.Button(u8'���������� �������� �� RolePlay',btnsizelawyer)
    if butlawyer_0 then idf = idhh
      lua_thread.create(function()
      sampSendChat('/me ������ ���')
       wait(500)
       sampSendChat('/me ����� � ���� ������ ��� � ��� ��� � ������� ������� ��������')
       wait(1000)
      sampSendChat('/free '..idhh..' 0')
      checkf = 'true'
    end)
     end
    if butlawyer_1 then
        freeid = idhh
        if tonumber(rank) ~= 5 then sampSendChat('/free '..freid)
        elseif #freid ~= 0 and tonumber(rank) == 5 and freedom ~= 'start' then sampAddChatMessage(tg..' ������� ID ������ ��� ��������� � ����������. (������� "K" ��� ������)',main_color)
      else
        math.randomseed(os.time())
        rand_free = math.random(0, 3)
          rpnamefree, rpsurnamefree = string.match(sampGetPlayerNickname(idhh), '(.+)_(.+)')
          if rand_free == 0 then
            sampSendChat('���� �� ������ ��������������� �������� ��������, �������� ��� ��� � �������.')
          elseif rand_free == 1 then
            sampSendChat('�� ������ ��������������� �������� ����������������� �������� '..mainIni.config.podrazd_name)
            sampSendChat('��� ����� ������ �������� ��� ��� � �������.')
          elseif rand_free == 2 then
            sampSendChat('������������, �� ������ ������ �������� ��� ���. ������ �������� ��� ��� � �������.')
          elseif rand_free == 3 then
            sampSendChat('�� ������ ��������������� ����� �������� ��������, ��� ������ �������������.')
          end
          lua_thread.create(function()
            wait(200)
          sampAddChatMessage(tg..' ������� ������� "J", ����� ���������� ��� "K" ��� ������.',main_color)
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
    imgui.Begin(u8'��������������� �����',imgui_gnews, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.TextQuestion2(u8"( ? )", u8"��� ����������� � ������� /gnews ������� �� �����!")
    imgui.Text(u8'3 ������:')
    local input1 = imgui.InputText(u8'##1', gnews_text_buffer_1)
    if input1 then mainIni.settings.gnews_line_1 = gnews_text_buffer_1.v end
    local input2 = imgui.InputText('##2', gnews_text_buffer_2)
    if input2 then mainIni.settings.gnews_line_2 = gnews_text_buffer_2.v end
    imgui.SameLine()
    if imgui.Button(u8'��������� 3 ������',imgui.ImVec2(145,0)) then
      if tonumber(rank) >= 10 then
      sampAddChatMessage(tg..' ',main_color)
    else sampAddChatMessage(tg..' ������� � ���. ����� �������� ������ ������� �����������.',main_color)
      end
    end
    local input3 = imgui.InputText('##3', gnews_text_buffer_3)
    if input3 then mainIni.settings.gnews_line_3 = gnews_text_buffer_3.v end
    imgui.Text(u8'�����������:')
    local input4 = imgui.InputText('##4', gnews_text_buffer_4)
    if input4 then mainIni.settings.gnews_line_4 = gnews_text_buffer_4.v end
    imgui.SameLine()
    if imgui.Button(u8'��������� �����������',imgui.ImVec2(145,0)) then
      if tonumber(rank) >= 10 then
      sampAddChatMessage(tg..' ',main_color)
    else sampAddChatMessage(tg..' ������� � ���. ����� �������� ������ ������� �����������.',main_color)
      end
    end
    imgui.Text(u8'�����:')
    local input5 = imgui.InputText('##5', gnews_text_buffer_5)
    if input5 then mainIni.settings.gnews_line_5 = gnews_text_buffer_5.v end
    imgui.SameLine()
    if imgui.Button(u8'��������� �����',imgui.ImVec2(145,0)) then
            if tonumber(rank) >= 10 then
            sampAddChatMessage(tg..' ',main_color)
          else sampAddChatMessage(tg..' ������� � ���. ����� �������� ������ ������� �����������.',main_color)
            end
    end
    imgui.Text(u8'\n������ �����: '..os.date('%H:%M:%S'))
    local proverka = imgui.Button(u8'���������',imgui.ImVec2(145,0))
    imgui.SameLine()
    local sohranit = imgui.Button(u8'���������',imgui.ImVec2(145,0))
    imgui.SameLine()
    local sbrosit = imgui.Button(u8'�������� ���������',imgui.ImVec2(145, 0))
    if sbrosit then
      mainIni.settings.gnews_line_1 = 'Ув. жители Федерации, минуту внимания!'
      mainIni.settings.gnews_line_2 = 'Проходит собеседование в мэрию г.Los-Santos! Требования:..'
      mainIni.settings.gnews_line_3 = '..4 года в Федерации, пакет документов и улыбка на лице. GPS: 3-3'
      mainIni.settings.gnews_line_4='Напоминаю, проходит собеседование в Мэрию Los-Santos. GPS: 3-3.'
      mainIni.settings.gnews_line_5='Собеседование в Мэрию Los-Santos закончено. Всем спасибо!'
      sampAddChatMessage(tg..' ��������� ������� ��������!',main_color)
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
      sampAddChatMessage(tg..' ������� ���������!',main_color)
    end
    imgui.End()
  end
  if imgui_mainmenu.v then
    local chosesize = imgui.ImVec2(150, 0)
    local actionsize = imgui.ImVec2(380, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.Always)
    imgui.Begin(u8'������� ����', imgui_mainmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.BeginChild('Chose menu', imgui.ImVec2(170, 300), true)
    imgui.Text(u8'�������� �����������\n\t\t ��� ���������')
    if imgui.Button(u8'[1]��������� ��', chosesize) then main_rank = 1 end
    if imgui.Button(u8'[2]��������� ��', chosesize) then main_rank = 2 end
    if imgui.Button(u8'[3]��� ��������', chosesize) then main_rank = 3 end
    if imgui.Button(u8'[4]���������', chosesize) then main_rank = 4 end
    if imgui.Button(u8'[5]������������', chosesize) then main_rank = 5 end
    if imgui.Button(u8'[6]����������', chosesize) then main_rank = 6 end
    if imgui.Button(u8'[7]�������', chosesize) then main_rank = 7 end
    if imgui.Button(u8'[8]������� ��', chosesize) then main_rank = 8 end
    if imgui.Button(u8'[9]����������� ����', chosesize) then main_rank = 9 end
    if imgui.Button(u8'[10]��� ������', chosesize) then main_rank = 10 end
    if imgui.Button(u8'[all]Flooder', chosesize) then main_rank = 11 end
    imgui.EndChild()
    imgui.SameLine()
    imgui.BeginChild('action menu', imgui.ImVec2(415,300),true)
    if main_rank == 1 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      local autodokl = imgui.Button(u8'���/���� ����������� � �����',actionsize)
      if autodokl and tonumber(rank) > 1 then
        sampAddChatMessage(tg..' �� ��� '..rankname..', ����� ���� �������?)',main_color)
      elseif autodokl and tonumber(rank) == 1 then
        sampAddChatMessage(tg..' �� Blue ���� �� ��������� ������� � ����� ��� ���������, ������ ������ ������ �� ����� :)',main_color)
      end
    elseif main_rank == 2 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      local autootvet = imgui.Button(u8'���/���� ����� �� �������',actionsize)
      if autootvet and tonumber(rank) == 2 then
        sampAddChatMessage(tg..' �� Blue ��� ������� �� ����� ������� � �����, �������������� ��������� �� ���� �� ����� ������.',main_color)
        sampAddChatMessage(tg..' ���������� �������� �����-�� ����������� ��� ����������� �� :)',main_color)
      elseif autootvet and tonumber(rank) ~= 2 then
        sampAddChatMessage(tg..' ������� �������� ������ ��� ����������� ��.', main_color)
      end


    elseif main_rank == 3 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end

      if imgui.CollapsingHeader(u8'���. ������') then
        lua_thread.create(function()

      if imgui.Button(u8'�������������, ���������� ������������� � ������.',actionsize) then
        sampSendChat('������������, � '..mainIni.config.rankname..', �� '..mainIni.config.podrazd)
        wait(800)
        sampSendChat('�� ������� ������������� � ���������� ������? ��� ������ ��������.')
      end
    end)

      if imgui.Button(u8'�������/�������� �������',actionsize) then

        if notebook == nil or notebook == false then
          lua_thread.create(function()
          notebook = true
          sampSendChat('/do ����� ����� ����� �����.')
          wait(500)
          sampSendChat('/me ������'..feminism..' ����� � ������'..feminism..' ������� � ������ ������� ������')
          wait(500)
          sampSendChat('/me ������'..feminism..' ������� �� ���� '..os.date('%D')..', ����� ������'..feminism..' �����')
        end)
        elseif notebook == true then
          sampSendChat('/me ������ �����, ����� � �� ����� � �������, ����� ������')
          notebook = false
        end
      end
      local bloknot = imgui.Button(u8'������� ������ � �������',actionsize)

      if bloknot and notebook then
        sampSendChat('/me ������'..feminism..' ������ � �������')
      elseif bloknot and not notebook then
        sampAddChatMessage(tg..' ��� ������ ������� �������!',main_color)
      end

      if imgui.Button(u8'������ ������ � ��������',actionsize) then
        math.randomseed(os.time())
        local rand_polit = math.random(0, 3)

        if rand_polit == 0 then
          sampSendChat('��� �� ���������� � ������ ����������?')
        elseif rand_polit == 1 then
          sampSendChat('��� �� ������� ������ ��������� '..mainIni.config.podrazd..'?')
        elseif rand_polit == 2 then
          sampSendChat('�� ��������� ������ ������ �������? ���-�� �������� � ���������?')
        elseif rand_polit == 3 then
          sampSendChat('�� ���������� ������� � ������� ����������?')
        end
      end

      if imgui.Button(u8'�������� �� ��������� � ���',actionsize) then
        math.randomseed(os.time())
        local rand_MVD = math.random(0, 3)

        if rand_MVD == 0 then
        sampSendChat('����� ���� ��������� � ����� � ���?')
      elseif rand_MVD == 1 then
        sampSendChat('���������� ���� 1 ��������� ��� �������������� ��� ���, ��� �������� �� ���.')
      elseif rand_MVD == 2 then
        sampSendChat('�� �����-������ �������� ������������������� ������ ����������� ���? ���������� �� ����')
      elseif rand_MVD == 3 then
        sampSendChat('���� �� ��� ���� ���� �����������, ���� �������?')
      end
    end
      if imgui.Button(u8'������ ������ � ��.',actionsize) then
        math.randomseed(os.time())
        local rand_MZ = math.random(0, 3)
        if rand_MZ == 0 then
        sampSendChat('��� �� ������ ������� ������ ���. ���������������?')
      elseif rand_MZ == 1 then
        sampSendChat('��� ���������� ���� �� ����������� ������������ � '..mainIni.config.podrazd_name..'?')
      elseif rand_MZ == 2 then
        sampSendChat('������� ������ �� �� 10 �������� �����, ��� 1 - ������, � 10 - �������.')
      elseif rand_MZ == 3 then
        sampSendChat('�������� � ��� ���� ���� �� ��������� ��? ���������� ��� ���')
      end
    end
      if imgui.Button(u8'������������� �������� �� �������',actionsize) then
        sampSendChat('��������� ��� �� ������� � ��� ������, �� ����� ������� ���������!')
      end
  end


    elseif main_rank == 4 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      if imgui.Button(fa.ICON_ID_CARD_O..u8' ������ ������� ���������/���������',actionsize) then
        lua_thread.create(function()
        sampSendChat('/do �� ����� ������ �������.')
          wait(800)
        sampSendChat('/me �������'..feminism..' ���� ������� � �������'..feminism..' �������� ��������')
        wait(500)
        sampSendChat('/n /liclist - ������ ��������� | /adlist - ������ ���������.')
      end)
      end
    elseif main_rank == 5 then
      imgui.TextQuestion2(fa.ICON_EYE, u8'�������� ���������� ������� � ������� ��������������(/hh id)')
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      local proverkall = imgui.Button(u8'��������� ���� ������ �� ���',actionsize)
      if proverkall and tonumber(rank)~=5 then
        sampAddChatMessage(tg..' ������� �������� ������ ��� ���������[5]. :(',main_color)
      elseif proverkall and tonumber(rank) == 5 then
      if checkall == true then checkall = false
        sampAddChatMessage(tg..' �������� ���������.',main_color)
          elseif checkall == false then
            checkall = true
            sampAddChatMessage(tg..' �������� ������!',main_color)
          lua_thread.create(function()
          for k, v in pairs(getAllChars()) do
            _, idmm = sampGetPlayerIdByCharHandle(v)
            sampSendChat("/free "..idmm..' 0')
            wait(1000)
            if msgmm:find('������� ����� �� 9000$ �� 30000$') or msgmm:find('��� ������ ������� ������') then
              sampAddChatMessage(tg..' {FF8C00}��������!{CECECE} ����� '..sampGetPlayerNickname(idmm)..'['..idmm..'] - {00FF00}�� ���{CECECE}!',main_color)
        end
          end
        end)
      end
      if imgui.Button(u8'������������(/ad)',actionsize) then
        sampSendChat('/ad �������� ������� �� '..mainIni.config.podrazd..'. �������!')
      end
      end
    elseif main_rank == 6 then
      imgui.TextQuestion2(fa.ICON_EYE, u8'�������� ���������� ������� � ������� ��������������(/hh id)')
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('������� ���������� ��������?')
        end)
    end
      if imgui.Button(u8'������������(/ad)',actionsize) then
        sampSendChat('/ad �������� ������� �� '..mainIni.config.podrazd..'. �������!')
      end
      if imgui.Button(u8'�������� ���������� ��� ������',actionsize) then
        briefing_SB = true
      end
      if imgui.CollapsingHeader(u8'����������') then
        lua_thread.create(function()
          local start = imgui.Button(u8'�����������',actionsize)
          local theend = imgui.Button(u8'��������� ����������(� ����� �������)', actionsize)
          if start then
            briefing = true
            sampSendChat(privet..', � ��� ���������� �� �������� - '..mainIni.config.name..' '..mainIni.config.surname..'!')
            wait(800)
            sampSendChat('� ���� � ���� �������� �� ������ � ��� ������������� ������������.')
            wait(800)
            sampSendChat('� ������, ���� �� ������� ������� ������������ �����, �� ��������...')
            wait(800)
            sampSendChat('..������ �� ���������������� ����� �� ����, ��� ��� �������� � 5.000$ ������ 10.000$')
            wait(800)
            sampSendChat('��������� ������� �� ����� �������, ���� ��� � ��� ��������.')
        elseif theend and briefing == true then
            briefing = false
            sampSendChat('���������� � �������� ������ ������������ �����, ������ �� �������� ���� �����.')
            wait(800)
            sampSendChat('���� ��������� ��� ������ �� ���������������� ����� � 50#, ��� ���...')
            wait(800)
            sampSendChat('��������� � 5.000$, ������ 10.000$ ��� ������.')
            wait(500)
            sampAddChatMessage(tg..' �� �������� ������� ��������!',main_color)
            sampSendChat('/c 060')
          elseif theend and briefing == false then
            sampAddChatMessage(tg..' ��� ������ ������� ����������!',main_color)
          end
        end)
      end
    elseif main_rank == 7 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('������� ���������� ��������?')
        end)
    end
      if imgui.Button(u8'������������(/ad)',actionsize) then
        sampSendChat('/ad �������� ������� �� '..mainIni.config.podrazd..'. �������!')
      end
    elseif main_rank == 8 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      if imgui.Button(u8'��������� ������',actionsize) then
        sampAddChatMessage(tg..' ������� ��������� � ����������.',main_color)
      end
    elseif main_rank == 9 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      if imgui.Button(u8'���� �����',actionsize) then
        sampAddChatMessage(tg..' ������� ��������� � ����������.',main_color)
      end
    elseif main_rank == 10 then
      if imgui.Button(u8'�������������',actionsize) then
        lua_thread.create(function()
          sampSendChat(privet..', � '..rankname..' - '..name..' '..surname..'!')
          wait(500)
          sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number..'.')
          wait(500)
          sampSendChat('��� ���-������ ����������?')
        end)
    end
      if imgui.Button(u8'���������� ����',actionsize) then
        sampAddChatMessage(tg..' ������� ��������� � ����������.',main_color)
      end
    elseif main_rank == 11 then
      if imgui.Button(u8'���/���� ������', actionsize) then
        flooder = not flooder
        sampAddChatMessage(tg..' �������!',main_color)
      end
      imgui.InputText('##1', bufferflooder)
      imgui.Text(u8'�������� �������: '..bufferflooder.v)
      imgui.Text(u8'���������: ������� K')
      if flooder then
      imgui.Text(u8'������: �����������.')
      else
        imgui.Text(u8'������: ���������.')
      end
    end
    imgui.EndChild()
    imgui.End()
  end
  if imgui_note.v then
    inicfg.load(nil, directIni)
    imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Government Helper - �������', imgui_note, imgui.WindowFlags.NoCollapse)
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
    imgui.Begin(u8'��', imgui_bl)
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

----------------------------------------------------------------------------------���� ������-----------------------------------------------------------------------------------
function cmd_qq()
lua_thread.create(function()
  if tonumber(rank) <5 or tonumber(rank) > 7 then
  sampSendChat('������������, � '..rankname..' - '..name..' '..surname..'!')
  wait(500)
  sampSendChat('/do ����� �������: '..rankname..' | '..name..' '..surname..' | '..number)
  wait(500)
  sampSendChat('��� � ���� ��� ������?')
elseif tonumber(rank) == 5 then
  sampSendChat('������������, � '..rankname..' - '..name..' '..surname..'!')
  wait(800)
  sampSendChat('�� ���������� � ������� ��������?')
  wait(800)
  sampSendChat('��� ����� ������ ��� 10.000$, ���� �� �� ���. ����������� ��� 9.000$, ���� ���.')
elseif tonumber(rank) == 6 or tonumber(rank) == 7 then
  sampSendChat('������������, � '..rankname..' - '..name..' '..surname..'!')
  wait(800)
  sampSendChat('�� ������� ���������� ��������?')
  wait(800)
  sampSendChat('� ������� ����. ����� �� ���� 10.000$ � �������� �� ������ - 30.000$')
end
end)
end

function fraction_cmd(fraction)
  if #fraction == 0 then sampSendChat('/f')
  elseif #fraction ~= 0 and mainIni.settings.rpradio == true then
    sampSendChat('/f '..fraction)
    sampSendChat('/me �������'..feminism..' ���-�� �� �����')
  elseif mainIni.settings.rpradio == false then
    sampSendChat('/f '..fraction)
    sampUnregisterChatCommand('f')
  end
end

function podrazd_cmd (podrazd_text)
  if #podrazd_text == 0 then sampSendChat('/r')
  elseif #podrazd_text ~= 0 and mainIni.settings.rpradio == true then
    sampSendChat('/r '..podrazd_text)
    sampSendChat('/me �������'..feminism..' ���-�� �� �����')
  elseif mainIni.settings.rpradio == false then
    sampSendChat('/r '..podrazd_text)
    sampUnregisterChatCommand('r')
  end
end

function cmd_rr(RadioOOC)
  if #RadioOOC == 0 then sampAddChatMessage(tg..' ����� �������� ��� ��������� � ��� ������������� ������� /rr [�����].',main_color)
  else  sampSendChat('/r (( '..RadioOOC..' ))') end
end

function cmd_ff(FractionOOC)
  if #FractionOOC == 0 then sampAddChatMessage(tg..' ����� �������� ��� ��������� � ��� ����������� ������� /ff [�����].',main_color)
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
  if tonumber(rank) < 9 then sampAddChatMessage(tg..' ��������� ����������� ����� � ��������� "����������� ����" � ����.',main_color)
  elseif #inv_id == 0 then sampAddChatMessage(tg..' ��� ����, ����� ���������� �������� � ����������� ������� /inv ID!',main_color)
  else
    lua_thread.create(function()
    sampSendChat('������ � ����� ��� ���� �����. ����� ������ ����� � ����� �� 2 �����.')
    wait(800)
    sampSendChat('/do � ����� ���� � �������.')
      wait(800)
      i_p_n = string.match(sampGetPlayerNickname(inv_id), '(.+)_')
    if sex == '�������' then
      sampSendChat('/me ������ ���� � ������� � ������� ���� � ���� '..i_p_n)
    elseif sex == '�������' then
      sampSendChat('/me ������� ���� � ������� � �������� ���� � ���� '..i_p_n)
    end
    wait(800)
    sampSendChat('/invite '..inv_id)
    local name_inv, surname_inv = string.match(sampGetPlayerNickname(inv_id), '(.+)_(.+)')
    sampSendChat('/r �������������� ������ ���������� ����� - '..name_inv..' '..surname_inv..'!')
  end)
  end
end

  function hiist_cmd(arg)
    if #arg == 0 then sampAddChatMessage(tg..' ����� ��������� ������� ���� �������� �� ��� ID ������� /hist ID',main_color)
    else
      histnick = sampGetPlayerNickname(arg)
       sampSendChat('/history '..histnick)
    end
  end

  function cmd_hh(hhid)
    if #hhid == 0 and interaction_window.v == true then interaction_window.v = not interaction_window.v
    elseif #hhid == 0 then sampAddChatMessage(tg..' ������� ID ������� ������ ��� ��������������.',main_color)
    elseif not sampIsPlayerConnected(hhid) then sampAddChatMessage(tg..' ������� ��������� ID ������ ��� ��������������.',main_color)
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
      sampSendChat('/r �������������� ������ ���������� - '..rpnameinv..' '..rpsurnameinv..'!')
      sampSendChat('/invite '..idinv)
    end
  end

function checkf_cmd(idf)
  if #idf == 0 then sampAddChatMessage(tg..' ������� ID ������, �������� ����� ���������',main_color)
  elseif rank ~= '5' then sampAddChatMessage(tg..' ������� �������� ������ ���������.',main_color)
  else
    lua_thread.create(function()
    sampSendChat('/me ������ ���')
     wait(500)
     sampSendChat('/me ����� � ���� ������ ��� � ��� ��� � ������� ������� ��������')
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
  elseif #freid == 0 and rank == '5' then sampAddChatMessage(tg..' ����� ���������� ������, ������� /fre ID',main_color)
  elseif #freid ~= 0 and rank == '5' and freedom ~= 'start' then sampAddChatMessage(tg..' ������� ID ������ ��� ��������� � ����������. (������� "K" ��� ������)',main_color)
else
  math.randomseed(os.time())
  rand_free = math.random(0, 3)
    rpnamefree, rpsurnamefree = string.match(sampGetPlayerNickname(freid), '(.+)_(.+)')
    if rand_free == 0 then
      sampSendChat('���� �� ������ ��������������� �������� ��������, �������� ��� ��� � �������.')
    elseif rand_free == 1 then
      sampSendChat('�� ������ ��������������� �������� ����������������� �������� '..mainIni.config.podrazd_name)
      sampSendChat('��� ����� ������ �������� ��� ��� � �������.')
    elseif rand_free == 2 then
      sampSendChat('������������, �� ������ ������ �������� ��� ���. ������ �������� ��� ��� � �������.')
    elseif rand_free == 3 then
      sampSendChat('�� ������ ��������������� ����� �������� ��������, ��� ������ �������������.')
    end
    lua_thread.create(function()
      wait(200)
    sampAddChatMessage(tg..' ������� ������� "J", ����� ���������� ��� "K" ��� ������.',main_color)
    freedom = 1
  end)
  end
end


function uninv_cmd(uninvarg)
  ID_uninv, reason_uninv = string.match(uninvarg,'(%d+) (.+)')
  if #uninvarg == 0 then
    sampAddChatMessage(tg..' ��� ����, ����� ������� �������� �� ����������� ������� /uninv ID *�������*!',main_color)
  elseif ID_uninv == nil or reason_uninv == nil then sampAddChatMessage(tg..' ������! �� �� ����� ������� ��� ID. /uninv ID *�������*!',main_color)
  elseif tonumber(rank) <8 then sampAddChatMessage(tg..' ��������� ����� � ��������� �������[8] � ����',main_color)
  else
    u_p_n, u_p_s = string.match(sampGetPlayerNickname(ID_uninv), '(.+)_(.+)')
    lua_thread.create(function()
    if mainIni.config.sex == '�������' then
      sampSendChat('/me ������ ��� � ������ ���� ������ ����������� �������������')
      wait(800)
      sampSendChat('/me ������ ������� �������� � ����� "�������"')
      wait(800)
      sampSendChat('/r ����������� ���� ���������� '..u_p_n..' '..u_p_s..'�� �������: '..reason_uninv)
    elseif mainIni.config.sex == '�������' then
      sampSendChat('/me ������� ��� � ������� ���� ������ ����������� �������������')
      wait(800)
      sampSendChat('/me ������� ������� �������� � ������ "�������"')
      wait(800)
      sampSendChat('/r ������������ ���� ���������� '..u_p_n..' '..u_p_s..'�� �������: '..reason_uninv)
      end
    end)
    end
end


  function addbl_cmd(addblarg)
    if #addblarg == 0 then sampAddChatMessage(tg..' ����� �������� ������ � ��������� ��, ������� /addbl [id/nickname] [�������]',main_color) return end
    ID_bl, reason_bl = addblarg:match('(.+) (.+)')
    local nickbl = sampGetPlayerNickname(tonumber(ID_bl))
  if ID_bl == 0 or reason_bl == 0 then sampAddChatMessage(tg..' {8B0000}������! {CECECE}�� �� ����� ID ������ ��� �������.',main_color) return end
  if tonumber(ID_bl) ~= nil then
    if sampIsPlayerConnected(tonumber(ID_bl)) then
      local file = io.open(getWorkingDirectory()..'/Government Helper/lblacklist.txt', 'a+')
      file:write(nickbl..' - '..reason_bl..'\n')
      file:close()
      sampAddChatMessage(tg..' �� ������� ������ ������ '..nickbl..'['..ID_bl..'] � ��������� �� (/lbl) �� �������: '..reason_bl..'.',main_color)
    else sampAddChatMessage(tg..' ����� �� ������.',main_color)
    end
        else
        local file = io.open(getWorkingDirectory()..'/Government Helper/lblacklist.txt', 'a+')
        sampAddChatMessage(tg..' �� ������� ������ ������ '..ID_bl..' � ��������� �� (/lbl) �� �������: '..reason_bl..'.',main_color)
        file:write(ID_bl..' - '..reason_bl..'\n')
        file:close()
    end
  end


  function cmd_lbl()
    local text = '�����\t�������'
        for line in io.lines(getWorkingDirectory().."/Government Helper/lblacklist.txt") do
            local nick, reason = line:match('(.+) %- (.+)')
            text = text..'\n'..nick..'\t'..reason
        end
        sampShowDialog(22228, "������ ������", text, "��������", "��", 5)
        local result, button, list, input = sampHasDialogRespond(22228)
          if result then
            if list == 0 then
        if button == 1 then sampAddChatMessage(tg..' ������� � ����������. ���� ��������������� �� �� ������ � moonloader -> Government Helper -> lblacklist.txt',main_color)
        else return end
      end
      end
    end
