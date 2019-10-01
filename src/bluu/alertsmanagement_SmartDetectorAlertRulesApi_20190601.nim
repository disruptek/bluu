
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2019-06-01
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  Call_SmartDetectorAlertRulesList_567880 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesList_567882(protocol: Scheme; host: string;
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

proc validate_SmartDetectorAlertRulesList_567881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the existing Smart Detector alert rules within the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   expandDetector: JBool
  ##                 : Indicates if Smart Detector should be expanded.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("expandDetector")
  valid_568057 = validateParameter(valid_568057, JBool, required = false, default = nil)
  if valid_568057 != nil:
    section.add "expandDetector", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_SmartDetectorAlertRulesList_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing Smart Detector alert rules within the subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_SmartDetectorAlertRulesList_567880;
          apiVersion: string; subscriptionId: string; expandDetector: bool = false): Recallable =
  ## smartDetectorAlertRulesList
  ## List all the existing Smart Detector alert rules within the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   expandDetector: bool
  ##                 : Indicates if Smart Detector should be expanded.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "expandDetector", newJBool(expandDetector))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var smartDetectorAlertRulesList* = Call_SmartDetectorAlertRulesList_567880(
    name: "smartDetectorAlertRulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.alertsManagement/smartDetectorAlertRules",
    validator: validate_SmartDetectorAlertRulesList_567881, base: "",
    url: url_SmartDetectorAlertRulesList_567882, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesListByResourceGroup_568193 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesListByResourceGroup_568195(protocol: Scheme;
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

proc validate_SmartDetectorAlertRulesListByResourceGroup_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   expandDetector: JBool
  ##                 : Indicates if Smart Detector should be expanded.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("expandDetector")
  valid_568199 = validateParameter(valid_568199, JBool, required = false, default = nil)
  if valid_568199 != nil:
    section.add "expandDetector", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_SmartDetectorAlertRulesListByResourceGroup_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_SmartDetectorAlertRulesListByResourceGroup_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expandDetector: bool = false): Recallable =
  ## smartDetectorAlertRulesListByResourceGroup
  ## List all the existing Smart Detector alert rules within the subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   expandDetector: bool
  ##                 : Indicates if Smart Detector should be expanded.
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "expandDetector", newJBool(expandDetector))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var smartDetectorAlertRulesListByResourceGroup* = Call_SmartDetectorAlertRulesListByResourceGroup_568193(
    name: "smartDetectorAlertRulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules",
    validator: validate_SmartDetectorAlertRulesListByResourceGroup_568194,
    base: "", url: url_SmartDetectorAlertRulesListByResourceGroup_568195,
    schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesCreateOrUpdate_568216 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesCreateOrUpdate_568218(protocol: Scheme;
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

proc validate_SmartDetectorAlertRulesCreateOrUpdate_568217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568236 = path.getOrDefault("resourceGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "resourceGroupName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("alertRuleName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "alertRuleName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
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

proc call*(call_568241: Call_SmartDetectorAlertRulesCreateOrUpdate_568216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a Smart Detector alert rule.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_SmartDetectorAlertRulesCreateOrUpdate_568216;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; alertRuleName: string): Recallable =
  ## smartDetectorAlertRulesCreateOrUpdate
  ## Create or update a Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  var body_568245 = newJObject()
  add(path_568243, "resourceGroupName", newJString(resourceGroupName))
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568245 = parameters
  add(path_568243, "alertRuleName", newJString(alertRuleName))
  result = call_568242.call(path_568243, query_568244, nil, nil, body_568245)

var smartDetectorAlertRulesCreateOrUpdate* = Call_SmartDetectorAlertRulesCreateOrUpdate_568216(
    name: "smartDetectorAlertRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesCreateOrUpdate_568217, base: "",
    url: url_SmartDetectorAlertRulesCreateOrUpdate_568218, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesGet_568204 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesGet_568206(protocol: Scheme; host: string;
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

proc validate_SmartDetectorAlertRulesGet_568205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568207 = path.getOrDefault("resourceGroupName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "resourceGroupName", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("alertRuleName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "alertRuleName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   expandDetector: JBool
  ##                 : Indicates if Smart Detector should be expanded.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  var valid_568211 = query.getOrDefault("expandDetector")
  valid_568211 = validateParameter(valid_568211, JBool, required = false, default = nil)
  if valid_568211 != nil:
    section.add "expandDetector", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_SmartDetectorAlertRulesGet_568204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific Smart Detector alert rule.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_SmartDetectorAlertRulesGet_568204;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertRuleName: string; expandDetector: bool = false): Recallable =
  ## smartDetectorAlertRulesGet
  ## Get a specific Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   expandDetector: bool
  ##                 : Indicates if Smart Detector should be expanded.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(query_568215, "expandDetector", newJBool(expandDetector))
  add(path_568214, "alertRuleName", newJString(alertRuleName))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var smartDetectorAlertRulesGet* = Call_SmartDetectorAlertRulesGet_568204(
    name: "smartDetectorAlertRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesGet_568205, base: "",
    url: url_SmartDetectorAlertRulesGet_568206, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesPatch_568257 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesPatch_568259(protocol: Scheme; host: string;
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

proc validate_SmartDetectorAlertRulesPatch_568258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a specific Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("alertRuleName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "alertRuleName", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
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

proc call*(call_568275: Call_SmartDetectorAlertRulesPatch_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a specific Smart Detector alert rule.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_SmartDetectorAlertRulesPatch_568257;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; alertRuleName: string): Recallable =
  ## smartDetectorAlertRulesPatch
  ## Patch a specific Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568279 = parameters
  add(path_568277, "alertRuleName", newJString(alertRuleName))
  result = call_568276.call(path_568277, query_568278, nil, nil, body_568279)

var smartDetectorAlertRulesPatch* = Call_SmartDetectorAlertRulesPatch_568257(
    name: "smartDetectorAlertRulesPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesPatch_568258, base: "",
    url: url_SmartDetectorAlertRulesPatch_568259, schemes: {Scheme.Https})
type
  Call_SmartDetectorAlertRulesDelete_568246 = ref object of OpenApiRestCall_567658
proc url_SmartDetectorAlertRulesDelete_568248(protocol: Scheme; host: string;
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

proc validate_SmartDetectorAlertRulesDelete_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing Smart Detector alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertRuleName: JString (required)
  ##                : The name of the alert rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568249 = path.getOrDefault("resourceGroupName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceGroupName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  var valid_568251 = path.getOrDefault("alertRuleName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "alertRuleName", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_SmartDetectorAlertRulesDelete_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing Smart Detector alert rule.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_SmartDetectorAlertRulesDelete_568246;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertRuleName: string): Recallable =
  ## smartDetectorAlertRulesDelete
  ## Delete an existing Smart Detector alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   alertRuleName: string (required)
  ##                : The name of the alert rule.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "alertRuleName", newJString(alertRuleName))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var smartDetectorAlertRulesDelete* = Call_SmartDetectorAlertRulesDelete_568246(
    name: "smartDetectorAlertRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.alertsManagement/smartDetectorAlertRules/{alertRuleName}",
    validator: validate_SmartDetectorAlertRulesDelete_568247, base: "",
    url: url_SmartDetectorAlertRulesDelete_568248, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
