#!/bin/bash
# Payload builder: https://app.slack.com/block-kit-builder/
set -euo pipefail
FAILURE=1
SUCCESS=0
SLACKWEBHOOKURL="https://hooks.slack.com/services/cccccccc/dvewfcwefw/efcewfvwevwevwe"
REPO_URL="https://gitlab.com/company/project"

function print_slack_summary() {
    local slack_msg_header
    local slack_msg_body
    local slack_channel="team_pde_jedi_pipeline"

    if [[ "${EXIT_STATUS}" == "$FAILURE" ]]; then
        slack_msg_header=":cowboy-cool-cry-mild-panic: *End to end tests failed!*"
    fi

        cat <<-SLACK
            {
                "channel": "${slack_channel}",
                "blocks": [
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": "${slack_msg_header}"
                        }
                    },
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": "${GITLAB_USER_NAME} (${GITLAB_USER_LOGIN}) pushed <$REPO_URL/-/commit/${CI_COMMIT_SHA}|this change> into ${CI_COMMIT_BRANCH}"
                        }
                    },
                    
                    {
                        "type": "actions",
                        "elements": [
                            {
                                "type": "button",
                                "text": {
                                    "type": "plain_text",
                                    "text": ":playwright-testing: Test Report",
                                    "emoji": true
                                },
                                "style": "primary",
                                "value": "${CI_JOB_URL}/artifacts/file/playwright-report/index.html",
                                "url": "${CI_JOB_URL}/artifacts/file/playwright-report/index.html"
                            },
                            {
                                "type": "button",
                                "text": {
                                    "type": "plain_text",
                                    "text": ":trex: Job Log",
                                    "emoji": true
                                },
                                "style": "primary",
                                "value": "${CI_JOB_URL}",
                                "url": "${CI_JOB_URL}"
                            }
                        ]
                    }
                ]
            }
SLACK
}

function share_slack_update() {
curl -X POST                                           \
        --data-urlencode "payload=$(print_slack_summary)"  \
        "$SLACKWEBHOOKURL"
}
