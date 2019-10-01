
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagementClient
## version: 2015-10-31
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_582458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582458): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "automation-webhook"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebhookListByAutomationAccount_582680 = ref object of OpenApiRestCall_582458
proc url_WebhookListByAutomationAccount_582682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookListByAutomationAccount_582681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of webhooks.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_582843 = path.getOrDefault("automationAccountName")
  valid_582843 = validateParameter(valid_582843, JString, required = true,
                                 default = nil)
  if valid_582843 != nil:
    section.add "automationAccountName", valid_582843
  var valid_582844 = path.getOrDefault("resourceGroupName")
  valid_582844 = validateParameter(valid_582844, JString, required = true,
                                 default = nil)
  if valid_582844 != nil:
    section.add "resourceGroupName", valid_582844
  var valid_582845 = path.getOrDefault("subscriptionId")
  valid_582845 = validateParameter(valid_582845, JString, required = true,
                                 default = nil)
  if valid_582845 != nil:
    section.add "subscriptionId", valid_582845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582846 = query.getOrDefault("api-version")
  valid_582846 = validateParameter(valid_582846, JString, required = true,
                                 default = nil)
  if valid_582846 != nil:
    section.add "api-version", valid_582846
  var valid_582847 = query.getOrDefault("$filter")
  valid_582847 = validateParameter(valid_582847, JString, required = false,
                                 default = nil)
  if valid_582847 != nil:
    section.add "$filter", valid_582847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582874: Call_WebhookListByAutomationAccount_582680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of webhooks.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_582874.validator(path, query, header, formData, body)
  let scheme = call_582874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582874.url(scheme.get, call_582874.host, call_582874.base,
                         call_582874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582874, url, valid)

proc call*(call_582945: Call_WebhookListByAutomationAccount_582680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## webhookListByAutomationAccount
  ## Retrieve a list of webhooks.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_582946 = newJObject()
  var query_582948 = newJObject()
  add(path_582946, "automationAccountName", newJString(automationAccountName))
  add(path_582946, "resourceGroupName", newJString(resourceGroupName))
  add(query_582948, "api-version", newJString(apiVersion))
  add(path_582946, "subscriptionId", newJString(subscriptionId))
  add(query_582948, "$filter", newJString(Filter))
  result = call_582945.call(path_582946, query_582948, nil, nil, nil)

var webhookListByAutomationAccount* = Call_WebhookListByAutomationAccount_582680(
    name: "webhookListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks",
    validator: validate_WebhookListByAutomationAccount_582681, base: "",
    url: url_WebhookListByAutomationAccount_582682, schemes: {Scheme.Https})
type
  Call_WebhookGenerateUri_582987 = ref object of OpenApiRestCall_582458
proc url_WebhookGenerateUri_582989(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks/generateUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookGenerateUri_582988(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Generates a Uri for use in creating a webhook.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_582990 = path.getOrDefault("automationAccountName")
  valid_582990 = validateParameter(valid_582990, JString, required = true,
                                 default = nil)
  if valid_582990 != nil:
    section.add "automationAccountName", valid_582990
  var valid_582991 = path.getOrDefault("resourceGroupName")
  valid_582991 = validateParameter(valid_582991, JString, required = true,
                                 default = nil)
  if valid_582991 != nil:
    section.add "resourceGroupName", valid_582991
  var valid_582992 = path.getOrDefault("subscriptionId")
  valid_582992 = validateParameter(valid_582992, JString, required = true,
                                 default = nil)
  if valid_582992 != nil:
    section.add "subscriptionId", valid_582992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582993 = query.getOrDefault("api-version")
  valid_582993 = validateParameter(valid_582993, JString, required = true,
                                 default = nil)
  if valid_582993 != nil:
    section.add "api-version", valid_582993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582994: Call_WebhookGenerateUri_582987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a Uri for use in creating a webhook.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_582994.validator(path, query, header, formData, body)
  let scheme = call_582994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582994.url(scheme.get, call_582994.host, call_582994.base,
                         call_582994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582994, url, valid)

proc call*(call_582995: Call_WebhookGenerateUri_582987;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## webhookGenerateUri
  ## Generates a Uri for use in creating a webhook.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_582996 = newJObject()
  var query_582997 = newJObject()
  add(path_582996, "automationAccountName", newJString(automationAccountName))
  add(path_582996, "resourceGroupName", newJString(resourceGroupName))
  add(query_582997, "api-version", newJString(apiVersion))
  add(path_582996, "subscriptionId", newJString(subscriptionId))
  result = call_582995.call(path_582996, query_582997, nil, nil, nil)

var webhookGenerateUri* = Call_WebhookGenerateUri_582987(
    name: "webhookGenerateUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks/generateUri",
    validator: validate_WebhookGenerateUri_582988, base: "",
    url: url_WebhookGenerateUri_582989, schemes: {Scheme.Https})
type
  Call_WebhookCreateOrUpdate_583010 = ref object of OpenApiRestCall_582458
proc url_WebhookCreateOrUpdate_583012(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookCreateOrUpdate_583011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   webhookName: JString (required)
  ##              : The webhook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_583039 = path.getOrDefault("automationAccountName")
  valid_583039 = validateParameter(valid_583039, JString, required = true,
                                 default = nil)
  if valid_583039 != nil:
    section.add "automationAccountName", valid_583039
  var valid_583040 = path.getOrDefault("resourceGroupName")
  valid_583040 = validateParameter(valid_583040, JString, required = true,
                                 default = nil)
  if valid_583040 != nil:
    section.add "resourceGroupName", valid_583040
  var valid_583041 = path.getOrDefault("webhookName")
  valid_583041 = validateParameter(valid_583041, JString, required = true,
                                 default = nil)
  if valid_583041 != nil:
    section.add "webhookName", valid_583041
  var valid_583042 = path.getOrDefault("subscriptionId")
  valid_583042 = validateParameter(valid_583042, JString, required = true,
                                 default = nil)
  if valid_583042 != nil:
    section.add "subscriptionId", valid_583042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583043 = query.getOrDefault("api-version")
  valid_583043 = validateParameter(valid_583043, JString, required = true,
                                 default = nil)
  if valid_583043 != nil:
    section.add "api-version", valid_583043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The create or update parameters for webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583045: Call_WebhookCreateOrUpdate_583010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_583045.validator(path, query, header, formData, body)
  let scheme = call_583045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583045.url(scheme.get, call_583045.host, call_583045.base,
                         call_583045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583045, url, valid)

proc call*(call_583046: Call_WebhookCreateOrUpdate_583010;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## webhookCreateOrUpdate
  ## Create the webhook identified by webhook name.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   webhookName: string (required)
  ##              : The webhook name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The create or update parameters for webhook.
  var path_583047 = newJObject()
  var query_583048 = newJObject()
  var body_583049 = newJObject()
  add(path_583047, "automationAccountName", newJString(automationAccountName))
  add(path_583047, "resourceGroupName", newJString(resourceGroupName))
  add(query_583048, "api-version", newJString(apiVersion))
  add(path_583047, "webhookName", newJString(webhookName))
  add(path_583047, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_583049 = parameters
  result = call_583046.call(path_583047, query_583048, nil, nil, body_583049)

var webhookCreateOrUpdate* = Call_WebhookCreateOrUpdate_583010(
    name: "webhookCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks/{webhookName}",
    validator: validate_WebhookCreateOrUpdate_583011, base: "",
    url: url_WebhookCreateOrUpdate_583012, schemes: {Scheme.Https})
type
  Call_WebhookGet_582998 = ref object of OpenApiRestCall_582458
proc url_WebhookGet_583000(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookGet_582999(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   webhookName: JString (required)
  ##              : The webhook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_583001 = path.getOrDefault("automationAccountName")
  valid_583001 = validateParameter(valid_583001, JString, required = true,
                                 default = nil)
  if valid_583001 != nil:
    section.add "automationAccountName", valid_583001
  var valid_583002 = path.getOrDefault("resourceGroupName")
  valid_583002 = validateParameter(valid_583002, JString, required = true,
                                 default = nil)
  if valid_583002 != nil:
    section.add "resourceGroupName", valid_583002
  var valid_583003 = path.getOrDefault("webhookName")
  valid_583003 = validateParameter(valid_583003, JString, required = true,
                                 default = nil)
  if valid_583003 != nil:
    section.add "webhookName", valid_583003
  var valid_583004 = path.getOrDefault("subscriptionId")
  valid_583004 = validateParameter(valid_583004, JString, required = true,
                                 default = nil)
  if valid_583004 != nil:
    section.add "subscriptionId", valid_583004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583005 = query.getOrDefault("api-version")
  valid_583005 = validateParameter(valid_583005, JString, required = true,
                                 default = nil)
  if valid_583005 != nil:
    section.add "api-version", valid_583005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583006: Call_WebhookGet_582998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_583006.validator(path, query, header, formData, body)
  let scheme = call_583006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583006.url(scheme.get, call_583006.host, call_583006.base,
                         call_583006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583006, url, valid)

proc call*(call_583007: Call_WebhookGet_582998; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; webhookName: string;
          subscriptionId: string): Recallable =
  ## webhookGet
  ## Retrieve the webhook identified by webhook name.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   webhookName: string (required)
  ##              : The webhook name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_583008 = newJObject()
  var query_583009 = newJObject()
  add(path_583008, "automationAccountName", newJString(automationAccountName))
  add(path_583008, "resourceGroupName", newJString(resourceGroupName))
  add(query_583009, "api-version", newJString(apiVersion))
  add(path_583008, "webhookName", newJString(webhookName))
  add(path_583008, "subscriptionId", newJString(subscriptionId))
  result = call_583007.call(path_583008, query_583009, nil, nil, nil)

var webhookGet* = Call_WebhookGet_582998(name: "webhookGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks/{webhookName}",
                                      validator: validate_WebhookGet_582999,
                                      base: "", url: url_WebhookGet_583000,
                                      schemes: {Scheme.Https})
type
  Call_WebhookUpdate_583062 = ref object of OpenApiRestCall_582458
proc url_WebhookUpdate_583064(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookUpdate_583063(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   webhookName: JString (required)
  ##              : The webhook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_583065 = path.getOrDefault("automationAccountName")
  valid_583065 = validateParameter(valid_583065, JString, required = true,
                                 default = nil)
  if valid_583065 != nil:
    section.add "automationAccountName", valid_583065
  var valid_583066 = path.getOrDefault("resourceGroupName")
  valid_583066 = validateParameter(valid_583066, JString, required = true,
                                 default = nil)
  if valid_583066 != nil:
    section.add "resourceGroupName", valid_583066
  var valid_583067 = path.getOrDefault("webhookName")
  valid_583067 = validateParameter(valid_583067, JString, required = true,
                                 default = nil)
  if valid_583067 != nil:
    section.add "webhookName", valid_583067
  var valid_583068 = path.getOrDefault("subscriptionId")
  valid_583068 = validateParameter(valid_583068, JString, required = true,
                                 default = nil)
  if valid_583068 != nil:
    section.add "subscriptionId", valid_583068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583069 = query.getOrDefault("api-version")
  valid_583069 = validateParameter(valid_583069, JString, required = true,
                                 default = nil)
  if valid_583069 != nil:
    section.add "api-version", valid_583069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The update parameters for webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583071: Call_WebhookUpdate_583062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the webhook identified by webhook name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_583071.validator(path, query, header, formData, body)
  let scheme = call_583071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583071.url(scheme.get, call_583071.host, call_583071.base,
                         call_583071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583071, url, valid)

proc call*(call_583072: Call_WebhookUpdate_583062; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; webhookName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## webhookUpdate
  ## Update the webhook identified by webhook name.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   webhookName: string (required)
  ##              : The webhook name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The update parameters for webhook.
  var path_583073 = newJObject()
  var query_583074 = newJObject()
  var body_583075 = newJObject()
  add(path_583073, "automationAccountName", newJString(automationAccountName))
  add(path_583073, "resourceGroupName", newJString(resourceGroupName))
  add(query_583074, "api-version", newJString(apiVersion))
  add(path_583073, "webhookName", newJString(webhookName))
  add(path_583073, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_583075 = parameters
  result = call_583072.call(path_583073, query_583074, nil, nil, body_583075)

var webhookUpdate* = Call_WebhookUpdate_583062(name: "webhookUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks/{webhookName}",
    validator: validate_WebhookUpdate_583063, base: "", url: url_WebhookUpdate_583064,
    schemes: {Scheme.Https})
type
  Call_WebhookDelete_583050 = ref object of OpenApiRestCall_582458
proc url_WebhookDelete_583052(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhookDelete_583051(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the webhook by name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   webhookName: JString (required)
  ##              : The webhook name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_583053 = path.getOrDefault("automationAccountName")
  valid_583053 = validateParameter(valid_583053, JString, required = true,
                                 default = nil)
  if valid_583053 != nil:
    section.add "automationAccountName", valid_583053
  var valid_583054 = path.getOrDefault("resourceGroupName")
  valid_583054 = validateParameter(valid_583054, JString, required = true,
                                 default = nil)
  if valid_583054 != nil:
    section.add "resourceGroupName", valid_583054
  var valid_583055 = path.getOrDefault("webhookName")
  valid_583055 = validateParameter(valid_583055, JString, required = true,
                                 default = nil)
  if valid_583055 != nil:
    section.add "webhookName", valid_583055
  var valid_583056 = path.getOrDefault("subscriptionId")
  valid_583056 = validateParameter(valid_583056, JString, required = true,
                                 default = nil)
  if valid_583056 != nil:
    section.add "subscriptionId", valid_583056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583057 = query.getOrDefault("api-version")
  valid_583057 = validateParameter(valid_583057, JString, required = true,
                                 default = nil)
  if valid_583057 != nil:
    section.add "api-version", valid_583057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583058: Call_WebhookDelete_583050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the webhook by name.
  ## 
  ## http://aka.ms/azureautomationsdk/webhookoperations
  let valid = call_583058.validator(path, query, header, formData, body)
  let scheme = call_583058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583058.url(scheme.get, call_583058.host, call_583058.base,
                         call_583058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583058, url, valid)

proc call*(call_583059: Call_WebhookDelete_583050; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; webhookName: string;
          subscriptionId: string): Recallable =
  ## webhookDelete
  ## Delete the webhook by name.
  ## http://aka.ms/azureautomationsdk/webhookoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   webhookName: string (required)
  ##              : The webhook name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_583060 = newJObject()
  var query_583061 = newJObject()
  add(path_583060, "automationAccountName", newJString(automationAccountName))
  add(path_583060, "resourceGroupName", newJString(resourceGroupName))
  add(query_583061, "api-version", newJString(apiVersion))
  add(path_583060, "webhookName", newJString(webhookName))
  add(path_583060, "subscriptionId", newJString(subscriptionId))
  result = call_583059.call(path_583060, query_583061, nil, nil, nil)

var webhookDelete* = Call_WebhookDelete_583050(name: "webhookDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/webhooks/{webhookName}",
    validator: validate_WebhookDelete_583051, base: "", url: url_WebhookDelete_583052,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
