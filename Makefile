main:
	@swift build
	@cp .build/debug/CLI openai
	@chmod +x openai
	@echo "Run the program with ./openai"

