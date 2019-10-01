
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
  macServiceName = "security-advancedThreatProtectionSettings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdvancedThreatProtectionCreate_568189 = ref object of OpenApiRestCall_567641
proc url_AdvancedThreatProtectionCreate_568191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment, value: "/providers/Microsoft.Security/advancedThreatProtectionSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvancedThreatProtectionCreate_568190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568192 = path.getOrDefault("settingName")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = newJString("current"))
  if valid_568192 != nil:
    section.add "settingName", valid_568192
  var valid_568193 = path.getOrDefault("resourceId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "resourceId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   advancedThreatProtectionSetting: JObject (required)
  ##                                  : Advanced Threat Protection Settings
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_AdvancedThreatProtectionCreate_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_AdvancedThreatProtectionCreate_568189;
          apiVersion: string; resourceId: string;
          advancedThreatProtectionSetting: JsonNode;
          settingName: string = "current"): Recallable =
  ## advancedThreatProtectionCreate
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   advancedThreatProtectionSetting: JObject (required)
  ##                                  : Advanced Threat Protection Settings
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  var body_568200 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "settingName", newJString(settingName))
  add(path_568198, "resourceId", newJString(resourceId))
  if advancedThreatProtectionSetting != nil:
    body_568200 = advancedThreatProtectionSetting
  result = call_568197.call(path_568198, query_568199, nil, nil, body_568200)

var advancedThreatProtectionCreate* = Call_AdvancedThreatProtectionCreate_568189(
    name: "advancedThreatProtectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionCreate_568190, base: "",
    url: url_AdvancedThreatProtectionCreate_568191, schemes: {Scheme.Https})
type
  Call_AdvancedThreatProtectionGet_567863 = ref object of OpenApiRestCall_567641
proc url_AdvancedThreatProtectionGet_567865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment, value: "/providers/Microsoft.Security/advancedThreatProtectionSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvancedThreatProtectionGet_567864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568051 = path.getOrDefault("settingName")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = newJString("current"))
  if valid_568051 != nil:
    section.add "settingName", valid_568051
  var valid_568052 = path.getOrDefault("resourceId")
  valid_568052 = validateParameter(valid_568052, JString, required = true,
                                 default = nil)
  if valid_568052 != nil:
    section.add "resourceId", valid_568052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568053 = query.getOrDefault("api-version")
  valid_568053 = validateParameter(valid_568053, JString, required = true,
                                 default = nil)
  if valid_568053 != nil:
    section.add "api-version", valid_568053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_AdvancedThreatProtectionGet_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_AdvancedThreatProtectionGet_567863;
          apiVersion: string; resourceId: string; settingName: string = "current"): Recallable =
  ## advancedThreatProtectionGet
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_568148 = newJObject()
  var query_568150 = newJObject()
  add(query_568150, "api-version", newJString(apiVersion))
  add(path_568148, "settingName", newJString(settingName))
  add(path_568148, "resourceId", newJString(resourceId))
  result = call_568147.call(path_568148, query_568150, nil, nil, nil)

var advancedThreatProtectionGet* = Call_AdvancedThreatProtectionGet_567863(
    name: "advancedThreatProtectionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionGet_567864, base: "",
    url: url_AdvancedThreatProtectionGet_567865, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
