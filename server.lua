ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('pxrp_vip:getVIPStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT vip FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(vip)
		if vip then
			print(('pxrp_vip: %s VIP status has been reset for the player!'):format(identifier))
		end

		cb(vip)
	end)
end)

RegisterServerEvent('pxrp_vip:setVIPStatus')
AddEventHandler('pxrp_vip:setVIPStatus', function(vip)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(vip) ~= 'boolean' then
		print(('pxrp_vip: %s attempted to parse something else than a boolean to setVIPStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET vip = @vip WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@vip'] = vip
	})
end)

ESX.RegisterCommand('addtbsvip', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('pxrp_vip:addVIPStatus')
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(158, 35, 35, 0.4); border-radius: 3px;"><i class="fas fa-globe"></i> <b>[USUARIO AGREGADO EN LA LISTA VIP]</b></i></div>'
		})	
end, true, {help = 'Добавяне на ВИП статус', validate = true, arguments = {
	{name = 'playerId', help = 'ID на играча', type = 'player'}
}})

ESX.RegisterCommand('deltbsvip', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('pxrp_vip:removeVIPStatus')
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(158, 35, 35, 0.4); border-radius: 3px;"><i class="fas fa-globe"></i> <b>[USUARIO QUITADO DE LA LISTA VIP]</b></i></div>'
		})	
end, true, {help = 'Премахване на ВИП статус', validate = true, arguments = {
	{name = 'playerId', help = 'ID на играча', type = 'player'}
}})