-- New GUI based on AceGUI. Better adapts to ElvUI, easier to work with
local AceGUI = LibStub("AceGUI-3.0")

-- The main GUI window. This is replacing the original XML-based window with something much cleaner.
-- This window automatically skins itself for ElvUI, too, natively.
function GuildTitheReincarnated.DrawMainUIFrame()
    if not GuildTithe_SavedDB.GUIIsShown then
        GuildTitheReincarnated.GTSettingsFrame = AceGUI:Create("Frame")
        GuildTitheReincarnated.GTSettingsFrame:SetCallback("OnClose",function(widget)
                GuildTithe_SavedDB.GUIIsShown = false
                AceGUI:Release(widget)
            end)
        GuildTitheReincarnated.GTSettingsFrame:SetTitle("GuildTithe Options")
        GuildTitheReincarnated.GTSettingsFrame:SetWidth(650)
        if IsInGuild() then
            GuildTitheReincarnated.GTSettingsFrame:SetHeight(730)
        else
            GuildTitheReincarnated.GTSettingsFrame:SetHeight(800) --increased height to display no-guild warning
        end
        GuildTitheReincarnated.GTSettingsFrame:SetStatusText(GuildTitheReincarnated.version)
        GuildTitheReincarnated.GTSettingsFrame:SetLayout("Flow")

        -- When we find that ESC press, we need to note that the GUI is hiding now.
        local GTESCDetector = KeyPressFrame or CreateFrame("Frame", "KeyPressFrame", UIParent) 
        local function KeyInput(self, key)
            if key == "ESCAPE" and GuildTithe_SavedDB.GUIIsShown == true then
                GuildTithe_SavedDB.GUIIsShown = false
            end
        end
        GTESCDetector:SetScript("OnKeyDown", KeyInput)
        GTESCDetector:SetPropagateKeyboardInput(true)

        -- Register with GUI to close when ESC pressed
        _G["GTGUIFrame"] = GuildTitheReincarnated.GTSettingsFrame.frame
        tinsert(UISpecialFrames, "GTGUIFrame")

        -- Loot category checkboxes
        local CheckboxHeader = AceGUI:Create("Heading")
        CheckboxHeader:SetText("Allow Collection From")
        CheckboxHeader:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(CheckboxHeader)

        local QuestRewardsToggle = AceGUI:Create("CheckBox")
        QuestRewardsToggle:SetType("checkbox")
        QuestRewardsToggle:SetValue(GuildTithe_SavedDB.CollectFrom["Quest"])
        QuestRewardsToggle:SetTriState(false)
        QuestRewardsToggle:SetLabel("Quest Rewards")
        QuestRewardsToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleCheckboxChange("Quest", value)
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(QuestRewardsToggle)

        local LootedMoneyToggle = AceGUI:Create("CheckBox")
        LootedMoneyToggle:SetType("checkbox")
        LootedMoneyToggle:SetValue(GuildTithe_SavedDB.CollectFrom["Loot"])
        LootedMoneyToggle:SetTriState(false)
        LootedMoneyToggle:SetLabel("Looted Money")
        LootedMoneyToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleCheckboxChange("Loot", value)
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(LootedMoneyToggle)

        local MerchantsToggle = AceGUI:Create("CheckBox")
        MerchantsToggle:SetValue(GuildTithe_SavedDB.CollectFrom["Merchant"])
        MerchantsToggle:SetType("checkbox")
        MerchantsToggle:SetTriState(false)
        MerchantsToggle:SetLabel("Merchants")
        MerchantsToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleCheckboxChange("Merchant", value)
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(MerchantsToggle)

        local MailToggle = AceGUI:Create("CheckBox")
        MailToggle:SetValue(GuildTithe_SavedDB.CollectFrom["Merchant"])
        MailToggle:SetType("checkbox")
        MailToggle:SetTriState(false)
        MailToggle:SetLabel("Mail")
        MailToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleCheckboxChange("Mail", value)
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(MailToggle)

        local TradeToggle = AceGUI:Create("CheckBox")
        TradeToggle:SetValue(GuildTithe_SavedDB.CollectFrom["Trade"])
        TradeToggle:SetType("checkbox")
        TradeToggle:SetTriState(false)
        TradeToggle:SetLabel("Trade")
        TradeToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleCheckboxChange("Trade", value)
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(TradeToggle)

        local PercentagesHeader = AceGUI:Create("Heading")
        PercentagesHeader:SetText("Percentage To Collect From")
        PercentagesHeader:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(PercentagesHeader)

        local QuestRewardsSlider = AceGUI:Create("Slider")
        QuestRewardsSlider:SetSliderValues(0.01,1,0.01)
        QuestRewardsSlider:SetValue(GuildTitheReincarnated.round(GuildTithe_SavedDB.CollectSource["Quest"])/100)
        QuestRewardsSlider:SetCallback("OnMouseUp",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleSliderChange("Quest", math.floor((value*100)+0.5))
                end
            )
        QuestRewardsSlider:SetRelativeWidth(1.0)
        QuestRewardsSlider:SetIsPercent(true)
        QuestRewardsSlider:SetLabel("Quest Rewards")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(QuestRewardsSlider)

        local LootedMoneySlider = AceGUI:Create("Slider")
        LootedMoneySlider:SetSliderValues(0.01,1,0.01)
        LootedMoneySlider:SetValue(GuildTitheReincarnated.round(GuildTithe_SavedDB.CollectSource["Loot"])/100)
        LootedMoneySlider:SetCallback("OnMouseUp",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleSliderChange("Loot", math.floor((value*100)+0.5))
                end
            )
        LootedMoneySlider:SetRelativeWidth(1.0)
        LootedMoneySlider:SetIsPercent(true)
        LootedMoneySlider:SetLabel("Looted Money")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(LootedMoneySlider)

        local MerchantsSlider = AceGUI:Create("Slider")
        MerchantsSlider:SetSliderValues(0.01,1,0.01)
        MerchantsSlider:SetValue(GuildTitheReincarnated.round(GuildTithe_SavedDB.CollectSource["Merchant"])/100)
        MerchantsSlider:SetCallback("OnMouseUp",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleSliderChange("Merchant", math.floor((value*100)+0.5))
                end
            )
        MerchantsSlider:SetRelativeWidth(1.0)
        MerchantsSlider:SetIsPercent(true)
        MerchantsSlider:SetLabel("Merchants")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(MerchantsSlider)

        local MailSlider = AceGUI:Create("Slider")
        MailSlider:SetSliderValues(0.01,1,0.01)
        MailSlider:SetValue(GuildTitheReincarnated.round(GuildTithe_SavedDB.CollectSource["Mail"])/100)
        MailSlider:SetCallback("OnMouseUp",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleSliderChange("Mail", math.floor((value*100)+0.5))
                end
            )
        MailSlider:SetRelativeWidth(1.0)
        MailSlider:SetIsPercent(true)
        MailSlider:SetLabel("Mail")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(MailSlider)

        local TradesSlider = AceGUI:Create("Slider")
        TradesSlider:SetSliderValues(0.01,1,0.01)
        TradesSlider:SetValue(GuildTitheReincarnated.round(GuildTithe_SavedDB.CollectSource["Trade"])/100)
        TradesSlider:SetCallback("OnMouseUp",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleSliderChange("Trade", math.floor((value*100)+0.5))
                end
            )
        TradesSlider:SetRelativeWidth(1.0)
        TradesSlider:SetIsPercent(true)
        TradesSlider:SetLabel("Trade")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(TradesSlider)

        local DepositSettingsHeader = AceGUI:Create("Heading")
        DepositSettingsHeader:SetText("Deposit Tithe To")
        DepositSettingsHeader:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(DepositSettingsHeader)

        -- Bottom Row
        local BottomRowText = AceGUI:Create("SimpleGroup")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(BottomRowText)

        -- Deposit Explainer
        local DepositExplainer = AceGUI:Create("Label")
        DepositExplainer:SetText("GuildTithe will deposit the accumulated tithe into the first enabled bank it encounters. By default, only the guild bank is selected.")
        DepositExplainer:SetColor(1,1,1)
        BottomRowText:AddChild(DepositExplainer)

        -- No-guild warning
        if not IsInGuild() then
            local NoGuild = AceGUI:Create("Label")
            NoGuild:SetText("This character is not in a guild. GuildTithe will do nothing if warband bank deposit is not enabled.")
            NoGuild:SetColor(1,0,0)
            BottomRowText:AddChild(NoGuild)
        end

        -- Deposit Settings Group
        local DepositSettingsGroup = AceGUI:Create("SimpleGroup")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(DepositSettingsGroup)

        -- Deposit settings checkboxes
        local GuildDepositToggle = AceGUI:Create("CheckBox")
        GuildDepositToggle:SetValue(GuildTithe_SavedDB.DepositToGuild)
        GuildDepositToggle:SetType("checkbox")
        GuildDepositToggle:SetTriState(false)
        GuildDepositToggle:SetLabel("Guild Bank")
        GuildDepositToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleDepositChange("Guild", value)
                end
            )
        DepositSettingsGroup:AddChild(GuildDepositToggle)

        local AccountDepositToggle = AceGUI:Create("CheckBox")
        AccountDepositToggle:SetType("checkbox")
        AccountDepositToggle:SetValue(GuildTithe_SavedDB.DepositToAccount)
        AccountDepositToggle:SetTriState(false)
        AccountDepositToggle:SetLabel("Warband Bank")
        AccountDepositToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated:HandleDepositChange("Account", value)
                end
            )
        DepositSettingsGroup:AddChild(AccountDepositToggle)

        local StatusDisplayHeader = AceGUI:Create("Heading")
        StatusDisplayHeader:SetText("Tithes")
        StatusDisplayHeader:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(StatusDisplayHeader)

        -- Status Display
        local StatusDisplay = AceGUI:Create("SimpleGroup")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(StatusDisplay)

        local CurrentTitheDisplay = AceGUI:Create("SFX-Info")
        CurrentTitheDisplay:SetLabel("Current")
        CurrentTitheDisplay:SetText(GuildTitheReincarnated.CurrentTithe)
        StatusDisplay:AddChild(CurrentTitheDisplay)

        local TotalTitheDisplay = AceGUI:Create("SFX-Info")
        TotalTitheDisplay:SetLabel("Total")
        TotalTitheDisplay:SetText(GuildTitheReincarnated.TotalTithe)
        StatusDisplay:AddChild(TotalTitheDisplay)

        local LastTitheAmountDisplay = AceGUI:Create("SFX-Info")
        LastTitheAmountDisplay:SetLabel("Last Tithe")
        local TextToShow = ""
        if GuildTithe_SavedDB.AmountOfLastDeposit == -1 then
            TextToShow = "This tracking will begin with the next deposit."
        else
            if GuildTithe_SavedDB.PrettyLDB then
                TextToShow = GetMoneyString(GuildTithe_SavedDB.AmountOfLastDeposit)
            else
                TextToShow = C_CurrencyInfo.GetCoinText(GuildTithe_SavedDB.AmountOfLastDeposit)
            end
            TextToShow = TextToShow .. " (deposited to " .. GuildTithe_SavedDB.TypeOfLastDeposit .. ")"
        end
        LastTitheAmountDisplay:SetText(TextToShow)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(LastTitheAmountDisplay)

        local LastTitheDateDisplay = AceGUI:Create("SFX-Info")
        LastTitheDateDisplay:SetLabel("Deposited")
        if GuildTithe_SavedDB.TimeOfLastDeposit == -1 then
            LastTitheDateDisplay:SetText("This tracking will begin with the next deposit.")
        else
            LastTitheDateDisplay:SetText(GuildTithe_SavedDB.TimeOfLastDeposit .. " (local time)")
        end
        GuildTitheReincarnated.GTSettingsFrame:AddChild(LastTitheDateDisplay)

        -- Toggles Display
        local TogglesHeader = AceGUI:Create("Heading")
        TogglesHeader:SetText("Settings")
        TogglesHeader:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(TogglesHeader)

        -- Minimap button control
        local MinimapButtonToggle = AceGUI:Create("CheckBox")
        MinimapButtonToggle:SetValue(not GuildTithe_SavedDB.HideMinimapIcon) -- "yes" hides
        MinimapButtonToggle:SetType("checkbox")
        MinimapButtonToggle:SetTriState(false)
        MinimapButtonToggle:SetLabel("Minimap Icon")
        MinimapButtonToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated.ToggleMinimapIcon()
                end
            )
        GuildTitheReincarnated.GTSettingsFrame:AddChild(MinimapButtonToggle)

        -- Pretty currency display control (To enable in next version)
        local PrettyLDBModeToggle = AceGUI:Create("CheckBox")
        PrettyLDBModeToggle:SetValue(GuildTithe_SavedDB.PrettyLDB) -- "yes" hides
        PrettyLDBModeToggle:SetType("checkbox")
        PrettyLDBModeToggle:SetTriState(false)
        PrettyLDBModeToggle:SetLabel("Graphical Coin Strings")
        PrettyLDBModeToggle:SetCallback("OnValueChanged",
                function(widget,callbackName,value)
                    GuildTitheReincarnated.TogglePrettyLDB()
                end
            )
        --GuildTitheReincarnated.GTSettingsFrame:AddChild(PrettyLDBModeToggle)

        --About section
        local ProjectInfo = AceGUI:Create("Heading")
        ProjectInfo:SetText("Addon Info")
        ProjectInfo:SetRelativeWidth(1.0)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(ProjectInfo)

        local AuthorNameDisplay = AceGUI:Create("SFX-Info")
        AuthorNameDisplay:SetLabel("Maintainer")
        AuthorNameDisplay:SetText("Miragosa")
        GuildTitheReincarnated.GTSettingsFrame:AddChild(AuthorNameDisplay)

        local ProjectURLDisplay = AceGUI:Create("SFX-Info-URL")
        ProjectURLDisplay:SetLabel("Source")
        ProjectURLDisplay:SetText("https://github.com/raptormama/GuildTithe-Reincarnated")
        ProjectURLDisplay:SetDisabled(false)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(ProjectURLDisplay)

        local CurseURLDisplay = AceGUI:Create("SFX-Info-URL")
        CurseURLDisplay:SetLabel("Curse")
        CurseURLDisplay:SetText("https://www.curseforge.com/wow/addons/guildtithe-reincarnated")
        CurseURLDisplay:SetDisabled(false)
        GuildTitheReincarnated.GTSettingsFrame:AddChild(CurseURLDisplay)

        GuildTithe_SavedDB.GUIIsShown = true
    end
end
