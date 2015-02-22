PROJECT_PATH?=Nursemaid.xcodeproj
PROJECT_NAME?=Nursemaid

test:
	@xctool \
		-project ${PROJECT_PATH} \
		-scheme ${PROJECT_NAME} \
		-sdk iphonesimulator \
		test
		-parallelize

.PHONY: test
