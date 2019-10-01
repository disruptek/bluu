
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2019-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for Azure Smart Detector Alert Rules CRUD operations.
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "alertsmanagement-SmartDetectorAlertRulesApi"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SmartDetectorAlertRulesList_567864 = ref object of OpenApiRestCall_567642
proc url_SmartDetectorAlertRulesList_567866(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.alertsManagement/smartDetectorAlertRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartDetectorAlertRulesList_567865(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the existing Smart Detector alert rules within the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568039 = path.getOrDefault("subscriptionId")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "subscriptionId", valid_568039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_SmartDetectorAlertRulesList_567864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing Smart Detector alert rules within the subscription.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_SmartDetectorAlertRulesList_567864;
          apiVersion: string; subscriptionId: string): Recallable =
  ## smartDetectorAlertRulesList
  ## List all the existing Smart Detector alert rules within the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription id.
  var path_568135 = newJObject()
  var query_568137 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  add(path_568135, "subscriptionId", newJString(subscriptionId))
  result = call_568134.call(path_568135, query_568137, nil, nil, nil)

var smartDetectorAlertRulesList* = Call_SmartDetectorAlertRulesList_567864(
    name: "smartDetectorAlertRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.alertsManagement/smartDetectorAlertRules",
    validator: validate_SmartDetectorAlertRulesList_567865, base: "",
    url: url_SmartDetectorAlertRulesList_567866, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesListByResourceGroup_568176 = ref object of OpenApiRestCall_567642
proc url_SmartDetectorAlertRulesListByResourceGroup_568178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.alertsManagement/smartDetectorAlertRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartDetectorAlertRulesListByResourceGroup_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568179 = path.getOrDefault("resourceGroupName")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "resourceGroupName", valid_568179
  var valid_568180 = path.getOrDefault("subscriptionId")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "subscriptionId", valid_568180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568181 = query.getOrDefault("api-version")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "api-version", valid_568181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568182: Call_SmartDetectorAlertRulesListByResourceGroup_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ## 
  let valid = call_568182.validator(path, query, header, formData, body)
  let scheme = call_568182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568182.url(scheme.get, call_568182.host, call_568182.base,
                         call_568182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568182, url, valid)

proc call*(call_568183: Call_SmartDetectorAlertRulesListByResourceGroup_568176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## smartDetectorAlertRulesListByResourceGroup
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription id.
  var path_568184 = newJObject()
  var query_568185 = newJObject()
  add(path_568184, "resourceGroupName", newJString(resourceGroupName))
  add(query_568185, "api-version", newJString(apiVersion))
  add(path_568184, "subscriptionId", newJString(subscriptionId))
  result = call_568183.call(path_568184, query_568185, nil, nil, nil)

var smartDetectorAlertRulesListByResourceGroup* = Call_SmartDetectorAlertRulesListByResourceGroup_568176(
    name: "smartDetectorAlertRulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules",
    validator: validate_SmartDetectorAlertRulesListByResourceGroup_568177,
    base: "", url: url_SmartDetectorAlertRulesListByResourceGroup_568178,
    schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesCreateOrUpdate_568198 = ref object of OpenApiRestCall_567642
proc url_SmartDetectorAlertRulesCreateOrUpdate_568200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "alertRuleName" in path, "`alertRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.alertsManagement/smartDetectorAlertRules/"),
               (kind: VariableSegment, value: "alertRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartDetectorAlertRulesCreateOrUpdate_568199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription id.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568218 = path.getOrDefault("resourceGroupName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "resourceGroupName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("alertRuleName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "alertRuleName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_SmartDetectorAlertRulesCreateOrUpdate_568198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a Smart Detector alert rule.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_SmartDetectorAlertRulesCreateOrUpdate_568198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; alertRuleName: string): Recallable =
  ## smartDetectorAlertRulesCreateOrUpdate
  ## Create or update a Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(path_568225, "resourceGroupName", newJString(resourceGroupName))
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  add(path_568225, "alertRuleName", newJString(alertRuleName))
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var smartDetectorAlertRulesCreateOrUpdate* = Call_SmartDetectorAlertRulesCreateOrUpdate_568198(
    name: "smartDetectorAlertRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesCreateOrUpdate_568199, base: "",
    url: url_SmartDetectorAlertRulesCreateOrUpdate_568200, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesGet_568186 = ref object of OpenApiRestCall_567642
proc url_SmartDetectorAlertRulesGet_568188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "alertRuleName" in path, "`alertRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.alertsManagement/smartDetectorAlertRules/"),
               (kind: VariableSegment, value: "alertRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartDetectorAlertRulesGet_568187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription id.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568189 = path.getOrDefault("resourceGroupName")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "resourceGroupName", valid_568189
  var valid_568190 = path.getOrDefault("subscriptionId")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "subscriptionId", valid_568190
  var valid_568191 = path.getOrDefault("alertRuleName")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "alertRuleName", valid_568191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   expandDetector: JBool
  ##                 : Indicates if Smart Detector should be expanded.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568192 = query.getOrDefault("api-version")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "api-version", valid_568192
  var valid_568193 = query.getOrDefault("expandDetector")
  valid_568193 = validateParameter(valid_568193, JBool, required = false, default = nil)
  if valid_568193 != nil:
    section.add "expandDetector", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_SmartDetectorAlertRulesGet_568186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific Smart Detector alert rule.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_SmartDetectorAlertRulesGet_568186;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertRuleName: string; expandDetector: bool = false): Recallable =
  ## smartDetectorAlertRulesGet
  ## Get a specific Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription id.
  ##   expandDetector: bool
  ##                 : Indicates if Smart Detector should be expanded.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(path_568196, "resourceGroupName", newJString(resourceGroupName))
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  add(query_568197, "expandDetector", newJBool(expandDetector))
  add(path_568196, "alertRuleName", newJString(alertRuleName))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var smartDetectorAlertRulesGet* = Call_SmartDetectorAlertRulesGet_568186(
    name: "smartDetectorAlertRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesGet_568187, base: "",
    url: url_SmartDetectorAlertRulesGet_568188, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesDelete_568228 = ref object of OpenApiRestCall_567642
proc url_SmartDetectorAlertRulesDelete_568230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "alertRuleName" in path, "`alertRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.alertsManagement/smartDetectorAlertRules/"),
               (kind: VariableSegment, value: "alertRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartDetectorAlertRulesDelete_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription id.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("alertRuleName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "alertRuleName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_SmartDetectorAlertRulesDelete_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing Smart Detector alert rule.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_SmartDetectorAlertRulesDelete_568228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertRuleName: string): Recallable =
  ## smartDetectorAlertRulesDelete
  ## Delete an existing Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription id.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "alertRuleName", newJString(alertRuleName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var smartDetectorAlertRulesDelete* = Call_SmartDetectorAlertRulesDelete_568228(
    name: "smartDetectorAlertRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesDelete_568229, base: "",
    url: url_SmartDetectorAlertRulesDelete_568230, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
