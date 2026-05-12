-- New GUI based on AceGUI. Better adapts to ElvUI, easier to work with
local AceGUI = LibStub("AceGUI-3.0")

local dataStore

-- Container frame

local frameHeight, frameWidth

function GuildTitheReincarnated.DrawMainUIFrame()
    GuildTitheReincarnated.GTSettingsFrame = AceGUI:Create("Frame")
    GuildTitheReincarnated.GTSettingsFrame:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    GuildTitheReincarnated.GTSettingsFrame:SetTitle("GuildTithe Options")
    GuildTitheReincarnated.GTSettingsFrame:SetWidth(650)
    GuildTitheReincarnated.GTSettingsFrame:SetHeight(650)
    GuildTitheReincarnated.GTSettingsFrame:SetStatusText(GuildTitheReincarnated.version)
    GuildTitheReincarnated.GTSettingsFrame:SetLayout("Flow")

    local CheckboxHeader = AceGUI:Create("Heading")
    CheckboxHeader:SetText("Allow Collection From")
    CheckboxHeader:SetRelativeWidth(1.0)
    GuildTitheReincarnated.GTSettingsFrame:AddChild(CheckboxHeader)

    local QuestRewardsToggle = AceGUI:Create("CheckBox")
    QuestRewardsToggle:SetType("checkbox")
    QuestRewardsToggle:SetTriState(false)
    QuestRewardsToggle:SetLabel("Quest Rewards")
    QuestRewardsToggle:SetCallback("OnValueChanged",
            function(value)
                GuildTitheReincarnated:HandleCheckboxChange("Quest", value)
            end
        )
    GuildTitheReincarnated.GTSettingsFrame:AddChild(QuestRewardsToggle)

    local LootedMoneyToggle = AceGUI:Create("CheckBox")
    LootedMoneyToggle:SetType("checkbox")
    LootedMoneyToggle:SetTriState(false)
    LootedMoneyToggle:SetLabel("Looted Money")
    GuildTitheReincarnated.GTSettingsFrame:AddChild(LootedMoneyToggle)

    local MerchantsToggle = AceGUI:Create("CheckBox")
    MerchantsToggle:SetType("checkbox")
    MerchantsToggle:SetTriState(false)
    MerchantsToggle:SetLabel("Merchants")
    GuildTitheReincarnated.GTSettingsFrame:AddChild(MerchantsToggle)

    local MailToggle = AceGUI:Create("CheckBox")
    MailToggle:SetType("checkbox")
    MailToggle:SetTriState(false)
    MailToggle:SetLabel("Mail")
    GuildTitheReincarnated.GTSettingsFrame:AddChild(MailToggle)

    local TradeToggle = AceGUI:Create("CheckBox")
    TradeToggle:SetType("checkbox")
    TradeToggle:SetTriState(false)
    TradeToggle:SetLabel("Trade")
    GuildTitheReincarnated.GTSettingsFrame:AddChild(TradeToggle)

    local PercentagesHeader = AceGUI:Create("Heading")
    PercentagesHeader:SetText("Percentage To Collect From")
    PercentagesHeader:SetRelativeWidth(1.0)
    GuildTitheReincarnated.GTSettingsFrame:AddChild(PercentagesHeader)

    local QuestRewardsSlider = AceGUI:Create("Slider")
    QuestRewardsSlider:SetSliderValues(0,1,0.01)
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
    LootedMoneySlider:SetSliderValues(0,1,0.01)
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
    MerchantsSlider:SetSliderValues(0,1,0.01)
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
    MailSlider:SetSliderValues(0,1,0.01)
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
    TradesSlider:SetSliderValues(0,1,0.01)
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
    local NoGuild = AceGUI:Create("Label")
    NoGuild:SetText("This character is not in a guild. GuildTithe will do nothing if warband bank deposit is not enabled.")
    NoGuild:SetColor(1,0,0)
    BottomRowText:AddChild(NoGuild)

    -- Deposit Settings Group
    local DepositSettingsGroup = AceGUI:Create("SimpleGroup")
    GuildTitheReincarnated.GTSettingsFrame:AddChild(DepositSettingsGroup)

    -- Deposit settings checkboxes
    local GuildDepositToggle = AceGUI:Create("CheckBox")
    GuildDepositToggle:SetType("checkbox")
    GuildDepositToggle:SetTriState(false)
    GuildDepositToggle:SetLabel("Guild Bank")
    DepositSettingsGroup:AddChild(GuildDepositToggle)

    local AccountDepositToggle = AceGUI:Create("CheckBox")
    AccountDepositToggle:SetType("checkbox")
    AccountDepositToggle:SetTriState(false)
    AccountDepositToggle:SetLabel("Warband Bank")
    DepositSettingsGroup:AddChild(AccountDepositToggle)
end
