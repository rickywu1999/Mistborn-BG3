PersistentVars = {}

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)
    if Osi.HasActiveStatus(target,"IRONREDIRECTION_PROTECTION") == 1 then
        if not PersistentVars['IronRedirectionSpellBlocked'] then
            PersistentVars['IronRedirectionSpellBlocked'] = nil
        end
        PersistentVars['IronRedirectionSpellBlocked'] = spell
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, _,_)
    if status == "IRONREDIRECTION_ACTIVATED" then
        Osi.UseSpell(object, PersistentVars['IronRedirectionSpellBlocked'],PersistentVars['IronRedirectionAuraOwner'])
        Osi.RemoveStatus(object,"IRONREDIRECTION_ACTIVATED","")
    end
    if status == "IRONREDIRECTION_AURA" then
        if not PersistentVars['IronRedirectionAuraOwner'] then
            PersistentVars['IronRedirectionAuraOwner'] = nil
        end
        PersistentVars['IronRedirectionAuraOwner']=object
    end
end)


