
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "security-autoProvisioningSettings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AutoProvisioningSettingsList_567863 = ref object of OpenApiRestCall_567641
proc url_AutoProvisioningSettingsList_567865(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568025 = path.getOrDefault("subscriptionId")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "subscriptionId", valid_568025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568026 = query.getOrDefault("api-version")
  valid_568026 = validateParameter(valid_568026, JString, required = true,
                                 default = nil)
  if valid_568026 != nil:
    section.add "api-version", valid_568026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568053: Call_AutoProvisioningSettingsList_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  let valid = call_568053.validator(path, query, header, formData, body)
  let scheme = call_568053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568053.url(scheme.get, call_568053.host, call_568053.base,
                         call_568053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568053, url, valid)

proc call*(call_568124: Call_AutoProvisioningSettingsList_567863;
          apiVersion: string; subscriptionId: string): Recallable =
  ## autoProvisioningSettingsList
  ## Exposes the auto provisioning settings of the subscriptions
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568125 = newJObject()
  var query_568127 = newJObject()
  add(query_568127, "api-version", newJString(apiVersion))
  add(path_568125, "subscriptionId", newJString(subscriptionId))
  result = call_568124.call(path_568125, query_568127, nil, nil, nil)

var autoProvisioningSettingsList* = Call_AutoProvisioningSettingsList_567863(
    name: "autoProvisioningSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings",
    validator: validate_AutoProvisioningSettingsList_567864, base: "",
    url: url_AutoProvisioningSettingsList_567865, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsCreate_568185 = ref object of OpenApiRestCall_567641
proc url_AutoProvisioningSettingsCreate_568187(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsCreate_568186(path: JsonNode;
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
  var valid_568188 = path.getOrDefault("settingName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "settingName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
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

proc call*(call_568192: Call_AutoProvisioningSettingsCreate_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_AutoProvisioningSettingsCreate_568185;
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
  var path_568194 = newJObject()
  var query_568195 = newJObject()
  var body_568196 = newJObject()
  add(query_568195, "api-version", newJString(apiVersion))
  add(path_568194, "settingName", newJString(settingName))
  add(path_568194, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_568196 = setting
  result = call_568193.call(path_568194, query_568195, nil, nil, body_568196)

var autoProvisioningSettingsCreate* = Call_AutoProvisioningSettingsCreate_568185(
    name: "autoProvisioningSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsCreate_568186, base: "",
    url: url_AutoProvisioningSettingsCreate_568187, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsGet_568166 = ref object of OpenApiRestCall_567641
proc url_AutoProvisioningSettingsGet_568168(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsGet_568167(path: JsonNode; query: JsonNode;
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
  var valid_568178 = path.getOrDefault("settingName")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "settingName", valid_568178
  var valid_568179 = path.getOrDefault("subscriptionId")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "subscriptionId", valid_568179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_AutoProvisioningSettingsGet_568166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_AutoProvisioningSettingsGet_568166;
          apiVersion: string; settingName: string; subscriptionId: string): Recallable =
  ## autoProvisioningSettingsGet
  ## Details of a specific setting
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "settingName", newJString(settingName))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var autoProvisioningSettingsGet* = Call_AutoProvisioningSettingsGet_568166(
    name: "autoProvisioningSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsGet_568167, base: "",
    url: url_AutoProvisioningSettingsGet_568168, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
