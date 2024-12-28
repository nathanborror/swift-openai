main:
	@swift build
	@cp .build/debug/OpenAICmd openai
	@chmod +x openai
	@echo "Run the program with ./openai"

