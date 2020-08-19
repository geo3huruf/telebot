require 'rubygems'
require 'telegram/bot'

token = '1355719289:'#Toke_key

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/help'
      bot.api.send_message(chat_id: message.chat.id, text: "• /start\n• /stop\n• /end\n, #{message.from.first_name}!")
    when '/test'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    when '/start'
      	question = 'London is a capital of which country?'
      	answers =
        	Telegram::Bot::Types::ReplyKeyboardMarkup
        	.new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
      	bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
    when '/stop'
    	kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    	bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
    when '/end'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    when Telegram::Bot::Types::CallbackQuery
    	if message.data == 'touch'
      	bot.api.send_message(chat_id: message.from.id, text: "Don't touch me!")
    	end
    when Telegram::Bot::Types::Message
    	kb = [
      	Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Go to Google', url: 'https://google.com'),
      	Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Touch me', callback_data: 'touch'),
      	Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Switch to inline', switch_inline_query: 'some text')
    	]
    	markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    	bot.api.send_message(chat_id: message.chat.id, text: 'Make a choice', reply_markup: markup)
    	
    when Telegram::Bot::Types::InlineQuery
    	results = [
      	[1, 'First article', 'Very interesting text goes here.'],
      	[2, 'Second article', 'Another interesting text here.']
    	].map do |arr|
      	Telegram::Bot::Types::InlineQueryResultArticle.new(
        	id: arr[0],
        	title: arr[1],
        	input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: arr[2]))
    	end
    	bot.api.answer_inline_query(inline_query_id: message.id, results: results)
    when Telegram::Bot::Types::Message
    	bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I don't understand you :(")
    end
  end
end
