-- Mỗi khi Script được thực thi, ID tương ứng sẽ được lưu trong hệ thống, tại bảng 'Scripts'
-- Dạng đối tượng là dạng Class, được khởi tạo mặc định bởi hệ thống, và sau đó được lưu tại bảng
-- Khi sử dụng dạng Class, cần phải kế thừa Class được hệ thống sinh ra, và dòng lệnh bên dưới để làm điều đó
-- ID Script được khai báo ở file ScriptIndex.xml, thay thế giá trị '000060' bên dưới thành ID tương ứng 
local DuVanTangNhan = Scripts[000060]

-- ****************************************************** --
--	Hàm này được gọi khi người chơi ấn vào NPC
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
-- ****************************************************** --
function DuVanTangNhan:OnOpen(scene, npc, player, otherParams)

	-- ************************** --
	local dialog = GUI.CreateNPCDialog()
	dialog:AddText(""..npc:GetName()..": nhiều năm nay , ta ngao du khăp nơi , tụng kinh giảng đạo, mong mổn độ hóa chúng sinh , gột rửa nghiệp chướng , để thể hiện lòng từ bi của ta.")
	dialog:AddSelection(1, "Ta phải sám hối để giảm nhẹ PK")	
	dialog:AddSelection(2, "Kết thúc đối thoại")	
	dialog:Show(npc, player)
	-- ************************** --

end

-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi ấn vào một trong số các chức năng cung cấp bởi NPC thông qua NPC Dialog
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
--		selectionID: number - ID chức năng
-- ****************************************************** --
function DuVanTangNhan:OnSelection(scene, npc, player, selectionID, otherParams)

	-- ************************** --
	local dialog = GUI.CreateNPCDialog()
	if selectionID == 1 then
		if player:GetPKValue(player)==0 then
			dialog:AddText(""..npc:GetName()..": Ngươi không có tội hãy về đi.")
			dialog:AddSelection(2, "Kết thúc đối thoại")
			dialog:Show(npc, player)
		else 
			dialog:AddText(npc:GetName() .. ":Ngươi muốn trừ đểm PK thì hãy hối lộ cho ta <color=yellow>500 (đồng)</color>, <color=yellow>5 vạn (bạc)</color>.")
			dialog:AddSelection(10, "Đồng ý")
			dialog:AddSelection(2, "Kết thúc đối thoại")
			dialog:Show(npc, player)		
		end
	end
	if selectionID ==2 then
		GUI.CloseDialog(player)
	end

	-- ************************** --
	if selectionID == 10 then
		if Player.CheckMoney(player, 2) <= 500 and Player.CheckMoney(player, 1) <= 5000 then
			--System.WriteToConsole("Đồng " .. Player.CheckMoney(player, 0) .. " và Bạc " .. Player.CheckMoney(player, 3) .. " của bạn.")
			local dialog = GUI.CreateNPCDialog()
			dialog:AddText("Số tiền mang theo không đủ!")
			dialog:Show(npc, player)
			return
		else
			Player.SetPKValue(player, 0)
			Player.MinusMoney(player,2, 500)
			Player.MinusMoney(player,1, 5000)
			
			local dialog = GUI.CreateNPCDialog()
			dialog:AddText("Xóa sát khí thành công, từ nay ngươi hãy cải tà quy chính, hi vọng không gặp lại ngươi ở đây thêm nữa!")
			dialog:Show(npc, player)
			--System.WriteToConsole("Điểm PK của ngươi"..Player.SetPKValue(player, 0).."")
		end
	end
end

-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi chọn một trong các vật phẩm, và ấn nút Xác nhận cung cấp bởi NPC thông qua NPC Dialog
--		scene: Scene - Bản đồ hiện tại
--		npc: NPC - NPC tương ứng
--		player: Player - NPC tương ứng
--		itemID: number - ID vật phẩm được chọn
-- ****************************************************** --
function DuVanTangNhan:OnItemSelected(scene, npc, player, itemID, otherParams)

	-- ************************** --
	
	-- ************************** --

end