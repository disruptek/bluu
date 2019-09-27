
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "security-autoProvisioningSettings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AutoProvisioningSettingsList_593630 = ref object of OpenApiRestCall_593408
proc url_AutoProvisioningSettingsList_593632(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Security/autoProvisioningSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593792 = path.getOrDefault("subscriptionId")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "subscriptionId", valid_593792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593793 = query.getOrDefault("api-version")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "api-version", valid_593793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593820: Call_AutoProvisioningSettingsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  let valid = call_593820.validator(path, query, header, formData, body)
  let scheme = call_593820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593820.url(scheme.get, call_593820.host, call_593820.base,
                         call_593820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593820, url, valid)

proc call*(call_593891: Call_AutoProvisioningSettingsList_593630;
          apiVersion: string; subscriptionId: string): Recallable =
  ## autoProvisioningSettingsList
  ## Exposes the auto provisioning settings of the subscriptions
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593892 = newJObject()
  var query_593894 = newJObject()
  add(query_593894, "api-version", newJString(apiVersion))
  add(path_593892, "subscriptionId", newJString(subscriptionId))
  result = call_593891.call(path_593892, query_593894, nil, nil, nil)

var autoProvisioningSettingsList* = Call_AutoProvisioningSettingsList_593630(
    name: "autoProvisioningSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings",
    validator: validate_AutoProvisioningSettingsList_593631, base: "",
    url: url_AutoProvisioningSettingsList_593632, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsCreate_593952 = ref object of OpenApiRestCall_593408
proc url_AutoProvisioningSettingsCreate_593954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/autoProvisioningSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsCreate_593953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_593955 = path.getOrDefault("settingName")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "settingName", valid_593955
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   setting: JObject (required)
  ##          : Auto provisioning setting key
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_AutoProvisioningSettingsCreate_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_AutoProvisioningSettingsCreate_593952;
          apiVersion: string; settingName: string; subscriptionId: string;
          setting: JsonNode): Recallable =
  ## autoProvisioningSettingsCreate
  ## Details of a specific setting
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   setting: JObject (required)
  ##          : Auto provisioning setting key
  var path_593961 = newJObject()
  var query_593962 = newJObject()
  var body_593963 = newJObject()
  add(query_593962, "api-version", newJString(apiVersion))
  add(path_593961, "settingName", newJString(settingName))
  add(path_593961, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_593963 = setting
  result = call_593960.call(path_593961, query_593962, nil, nil, body_593963)

var autoProvisioningSettingsCreate* = Call_AutoProvisioningSettingsCreate_593952(
    name: "autoProvisioningSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsCreate_593953, base: "",
    url: url_AutoProvisioningSettingsCreate_593954, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsGet_593933 = ref object of OpenApiRestCall_593408
proc url_AutoProvisioningSettingsGet_593935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/autoProvisioningSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsGet_593934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_593945 = path.getOrDefault("settingName")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "settingName", valid_593945
  var valid_593946 = path.getOrDefault("subscriptionId")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "subscriptionId", valid_593946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_AutoProvisioningSettingsGet_593933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_AutoProvisioningSettingsGet_593933;
          apiVersion: string; settingName: string; subscriptionId: string): Recallable =
  ## autoProvisioningSettingsGet
  ## Details of a specific setting
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "settingName", newJString(settingName))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var autoProvisioningSettingsGet* = Call_AutoProvisioningSettingsGet_593933(
    name: "autoProvisioningSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsGet_593934, base: "",
    url: url_AutoProvisioningSettingsGet_593935, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
