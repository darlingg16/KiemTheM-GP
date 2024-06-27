 -- Mỗi khi Script được thực thi, ID tương ứng sẽ được lưu trong hệ thống, tại bảng 'Scripts'
-- Dạng đối tượng là dạng Class, được khởi tạo mặc định bởi hệ thống, và sau đó được lưu tại bảng
-- Khi sử dụng dạng Class, cần phải kế thừa Class được hệ thống sinh ra, và dòng lệnh bên dưới để làm điều đó
-- ID Script được khai báo ở file ScriptIndex.xml, thay thế giá trị '0000152' bên dưới thành ID tương ứng
local ChuongMon = Scripts[0000152]

-- ************************** --
local LenhBaiTayTuyDao = 336
local TuLuyenChau = 215
-- ************************** --

--****************************************************** --
--	Hàm này được gọi khi người chơi ấn vào NPC
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
-- ****************************************************** --
function ChuongMon:OnOpen(scene, npc, player,otherParams)

	-- ************************** --
	-- Nếu chưa có môn phái
	if player:GetFactionID() == 0 then
		local dialog = GUI.CreateNPCDialog()
		dialog:AddText("Chưởng Môn: Ngươi có cốt cách dị thường tư chất hơn người, mai đây ắt sẽ làm nên nghiệp lớn. <br><color=#00ff44>Nếu muốn quay về Tân Thủ Thôn, hãy đến gặp người Truyền Tống Môn Phái</color>.")
		dialog:AddSelection(1, "Sư Phụ, xin nhận của đệ tử một lạy")
		dialog:AddSelection(2, "Để ta suy nghĩ sau")
		dialog:Show(npc, player)
	-- Nếu môn phái tồn tại
	elseif Global_NameMapItemPhaiID[scene:GetID()] ~= nil then
		-- Thông tin môn phái tương ứng
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Nếu trùng với môn phái này
		if factionInfo.FactionID == player:GetFactionID() then
			local dialog = GUI.CreateNPCDialog()
			dialog:AddText("Chưởng Môn: Lâu lắm không gặp ngươi " .. player:GetFactionName() .. ", nhận thấy ngươi rất có tố chất, xứng danh với môn đồ bản phái. Ngươi muốn sư phụ giúp gì?")
			dialog:AddSelection(3, "Nhận Ngũ hành ấn")
			dialog:AddSelection(4, "Nhận Mật tịch Môn Phái (sơ)")
			dialog:AddSelection(5, "Nhận Tu Luyện Châu")
			dialog:AddSelection(6, "Ta muốn mua trang bị thi đấu mốn phái")
			dialog:AddSelection(7, "Hoạt động thi đấu môn phái")
			dialog:AddSelection(8, "Được phong Đại sư huynh(Đại sư tỷ)")
			dialog:AddSelection(2, "Để ta suy nghĩ sau")
			dialog:Show(npc, player)
		-- Nếu ở phái khác
		else
			local dialog = GUI.CreateNPCDialog()
			dialog:AddText("Chưởng Môn: Ngươi đến bản phái phải chăng là muốn thách thức tỷ võ?")
			dialog:AddSelection(2, "Kết thúc đối thoại")
			dialog:Show(npc, player)
			
		end
	end
end

	-- ************************** --


-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi ấn vào một trong số các chức năng cung cấp bởi NPC thông qua NPC Dialog
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
--		selectionID: number - ID chức năng
-- ****************************************************** --
function ChuongMon:OnSelection(scene, npc, player, selectionID,otherParams)
	
	-- ************************** --
	if selectionID == 2 then
		GUI.CloseDialog(player)
		return
	end
	-- ************************** --
	if selectionID == 1 then
		-- Nếu đã có phái thì toác
		if player:GetFactionID() ~= 0 then
			self:ShowDialog(npc, player, "Ngươi đã gia nhập môn phái, không thể gia nhập thêm!")
			return
		end
		
		-- Nếu toác
		if Global_NameMapItemPhaiID[scene:GetID()] == nil then
			self:ShowDialog(npc, player, "Thông tin môn phái bị lỗi, hãy thử lại sau!")
			return
		end
		
		-- Kiểm tra túi đủ chỗ trống không
		if Player.HasFreeBagSpaces(player, 3) == false then
			self:ShowDialog(npc, player, "Ta có phần quà nhập môn dành cho ngươi, hãy sắp xếp <color=green>3 ô trống</color> trong túi để nhận!")
			return
		end
		
		-- Thông tin môn phái
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Cho vào môn phái
		self:JoinFaction(scene, npc, player, factionInfo.FactionID)
		
		-- Thêm 3 lệnh bài Tẩy Tủy Đảo
		Player.AddItemLua(player, LenhBaiTayTuyDao, 3, -1, 1)
		
		return
	end
	-- ************************** --
	if selectionID == 3 then
		-- Nếu toác
		if Global_NameMapItemPhaiID[scene:GetID()] == nil then
			self:ShowDialog(npc, player, "Thông tin môn phái bị lỗi, hãy thử lại sau!")
			return
		end
		
		-- Thông tin môn phái
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Nếu không phải đệ tử môn phái
		if player:GetFactionID() ~= factionInfo.FactionID then
			self:ShowDialog(npc, player, "Ngươi không phải đệ tử bản phái!")
			return
		end
		
		-- Kiểm tra túi đủ chỗ trống không
		if Player.HasFreeBagSpaces(player, 1) == false then
			self:ShowDialog(npc, player, "Túi của ngươi đã đầy, hãy sắp xếp <color=green>1 ô trống</color> trong túi để nhận Ngũ Hành Ấn!")
			return
		end
		
		-- Thêm vật phẩm
		Player.AddItemLua(player, factionInfo.press, 1, Player.GetSeries(player), 1)
		
		-- Thông báo nhận thành công
		self:ShowDialog(npc, player, "Nhận Ngũ Hành Ấn thành công!")
		return
	end
	-- ************************** --
	if selectionID == 4 then
		-- Nếu toác
		if Global_NameMapItemPhaiID[scene:GetID()] == nil then
			self:ShowDialog(npc, player, "Thông tin môn phái bị lỗi, hãy thử lại sau!")
			return
		end
		
		-- Thông tin môn phái
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Nếu không phải đệ tử môn phái
		if player:GetFactionID() ~= factionInfo.FactionID then
			self:ShowDialog(npc, player, "Ngươi không phải đệ tử bản phái!")
			return
		end
		
		-- Kiểm tra túi đủ chỗ trống không
		if Player.HasFreeBagSpaces(player, 2) == false then
			self:ShowDialog(npc, player, "Túi của ngươi đã đầy, hãy sắp xếp <color=green>2 ô trống</color> trong túi để nhận Mật tịch môn phái (sơ)!")
			return
		end
		
		-- Thêm vật phẩm
		Player.AddItemLua(player, factionInfo.secret1, 1, Player.GetSeries(player), 1)
		Player.AddItemLua(player, factionInfo.secret2, 1, Player.GetSeries(player), 1)
		
		-- Thông báo nhận thành công
		self:ShowDialog(npc, player, "Nhận Ngũ Hành Ấn thành công!")

		return
	end
	-- ************************** --
	if selectionID == 5 then
		-- Nếu toác
		if Global_NameMapItemPhaiID[scene:GetID()] == nil then
			self:ShowDialog(npc, player, "Thông tin môn phái bị lỗi, hãy thử lại sau!")
			return
		end
		
		-- Thông tin môn phái
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Nếu không phải đệ tử môn phái
		if player:GetFactionID() ~= factionInfo.FactionID then
			self:ShowDialog(npc, player, "Ngươi không phải đệ tử bản phái!")
			return
		end
		
		-- Kiểm tra túi đủ chỗ trống không
		if Player.HasFreeBagSpaces(player, 1) == false then
			self:ShowDialog(npc, player, "Túi của ngươi đã đầy, hãy sắp xếp <color=green>1 ô trống</color> trong túi để nhận Mật tịch môn phái (sơ)!")
			return
		end
		
		-- Thêm vật phẩm
		Player.AddItemLua(player, TuLuyenChau, 1, -1, 1)
		
		-- Thông báo nhận thành công
		self:ShowDialog(npc, player, "Nhận Tu Luyện Châu thành công!")
		return
	end
	-- ************************** --
	if selectionID == 6 then
		if player:GetLevel() >= 10 then
			if player:GetFactionID() == 1 then
				Player.OpenShop(npc, player,25)
			elseif player:GetFactionID() == 2 then
				Player.OpenShop(npc, player, 26)
			elseif player:GetFactionID() == 3 then
				Player.OpenShop(npc, player, 27)
			elseif player:GetFactionID() == 4 then
				Player.OpenShop(npc, player, 29)
			elseif player:GetFactionID() == 5 then
				Player.OpenShop(npc, player, 31)
			elseif player:GetFactionID() == 6 then
				Player.OpenShop(npc, player, 32)
			elseif player:GetFactionID() == 7 then
				Player.OpenShop(npc, player, 34)
			elseif player:GetFactionID() == 8 then
				Player.OpenShop(npc, player, 33)
			elseif player:GetFactionID() == 9 then
				Player.OpenShop(npc, player, 35)
			elseif player:GetFactionID() == 10 then
				Player.OpenShop(npc, player, 36)
			elseif player:GetFactionID() == 11 then
				Player.OpenShop(npc, player, 28)
			elseif player:GetFactionID() == 12 then
				Player.OpenShop(npc, player, 30)
			end
			GUI.CloseDialog(player)
		else
			self:ShowDialog(npc, player, "Ngươi chưa đủ cấp để có thể tham quan cửa hàng!")
		end
		
		return
	end
	-- ************************** --
	if selectionID==103 then
		-- Nếu toác
		if Global_NameMapItemPhaiID[scene:GetID()] == nil then
			self:ShowDialog(npc, player, "Thông tin môn phái bị lỗi, hãy thử lại sau!")
			return
		end
		
		-- Thông tin môn phái
		local factionInfo = Global_NameMapItemPhaiID[scene:GetID()]
		
		-- Nếu không phải đệ tử môn phái
		if player:GetFactionID() ~= factionInfo.FactionID then
			self:ShowDialog(npc, player, "Ngươi không phải đệ tử bản phái!")
			return
		end
		
		-- Đưa vào đấu trường thi đấu môn phái
		Player.JoinFactionBattle(npc, player)
		return
	end
	
	if selectionID == 7 then
		local dialog = GUI.CreateNPCDialog()
		dialog:AddText("Thi đấu môn phái vào tối thứ 3 và thứ 6 hàng tuần sẽ bắt đầu báo danh - 20:00 Sẽ bắt đầu\n<color=red>Điểm của mỗi lần thi đấu sẽ được thay đổi ở những lần thi tiếp theo</color>.")
		dialog:AddSelection(103, "Ta muốn tham gia thi đấu môn phái")
		dialog:AddSelection(2, "Ta đã hiểu")
		dialog:Show(npc, player)
		return
	end
	-- ************************** --
	if selectionID == 8 then
		self:ShowDialog(npc, player, "Chức năng này đang được phát triển!")
		return
	end
	-- ************************** --

end

-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi chọn một trong các vật phẩm, và ấn nút Xác nhận cung cấp bởi NPC thông qua NPC Dialog
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
--		itemID: number - ID vật phẩm được chọn
-- ****************************************************** --
function ChuongMon:OnItemSelected(scene, npc, player, itemID,otherParams)

	-- ************************** --
	
	-- ************************** --

end


function ChuongMon:JoinFaction(scene, npc, player, factionID)
	
	-- ************************** --
	local ret = player:JoinFaction(factionID)
	-- ************************** --
	if ret == -1 then
		ChuongMon:ShowDialog(npc, player, "Người chơi không tồn tại!")
		return
	elseif ret == -2 then
		ChuongMon:ShowDialog(npc, player, "Môn phái không tồn tại!")
		return
	elseif ret == 0 then
		ChuongMon:ShowDialog(npc, player, "Giới tính của bạn không phù hợp với môn phái này!")
		return
	elseif ret == 1 then
		ChuongMon:ShowDialog(npc, player, "Gia nhập phái <color=blue>" .. player:GetFactionName() .. "</color> thành công! Nhận được 3 cái Lệnh Bài Tẩy Tủy Đảo")
		return
	else
		ChuongMon:ShowDialog(npc, player, "Chuyển phái thất bại, lỗi chưa rõ!")
		return
	end
	-- ************************** --

end


function ChuongMon:ShowDialog(npc, player, text)

	-- ************************** --
	local dialog = GUI.CreateNPCDialog()
	dialog:AddText(text)
	dialog:Show(npc, player)
	-- ************************** --
	
end