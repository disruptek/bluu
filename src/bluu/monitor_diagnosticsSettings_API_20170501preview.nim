
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2017-05-01-preview
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-diagnosticsSettings_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiagnosticSettingsList_567879 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsList_567881(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsList_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the active diagnostic settings list for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568054 = path.getOrDefault("resourceUri")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceUri", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_DiagnosticSettingsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic settings list for the specified resource.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_DiagnosticSettingsList_567879; apiVersion: string;
          resourceUri: string): Recallable =
  ## diagnosticSettingsList
  ## Gets the active diagnostic settings list for the specified resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "resourceUri", newJString(resourceUri))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var diagnosticSettingsList* = Call_DiagnosticSettingsList_567879(
    name: "diagnosticSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings",
    validator: validate_DiagnosticSettingsList_567880, base: "",
    url: url_DiagnosticSettingsList_567881, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsCreateOrUpdate_568201 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsCreateOrUpdate_568203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsCreateOrUpdate_568202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates diagnostic settings for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568204 = path.getOrDefault("name")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "name", valid_568204
  var valid_568205 = path.getOrDefault("resourceUri")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceUri", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
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

proc call*(call_568208: Call_DiagnosticSettingsCreateOrUpdate_568201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates diagnostic settings for the specified resource.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_DiagnosticSettingsCreateOrUpdate_568201;
          apiVersion: string; name: string; resourceUri: string; parameters: JsonNode): Recallable =
  ## diagnosticSettingsCreateOrUpdate
  ## Creates or updates diagnostic settings for the specified resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  var body_568212 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "name", newJString(name))
  add(path_568210, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_568212 = parameters
  result = call_568209.call(path_568210, query_568211, nil, nil, body_568212)

var diagnosticSettingsCreateOrUpdate* = Call_DiagnosticSettingsCreateOrUpdate_568201(
    name: "diagnosticSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsCreateOrUpdate_568202, base: "",
    url: url_DiagnosticSettingsCreateOrUpdate_568203, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsGet_568191 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsGet_568193(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsGet_568192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the active diagnostic settings for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568194 = path.getOrDefault("name")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "name", valid_568194
  var valid_568195 = path.getOrDefault("resourceUri")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "resourceUri", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_DiagnosticSettingsGet_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic settings for the specified resource.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_DiagnosticSettingsGet_568191; apiVersion: string;
          name: string; resourceUri: string): Recallable =
  ## diagnosticSettingsGet
  ## Gets the active diagnostic settings for the specified resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "name", newJString(name))
  add(path_568199, "resourceUri", newJString(resourceUri))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var diagnosticSettingsGet* = Call_DiagnosticSettingsGet_568191(
    name: "diagnosticSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsGet_568192, base: "",
    url: url_DiagnosticSettingsGet_568193, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsDelete_568213 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsDelete_568215(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsDelete_568214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes existing diagnostic settings for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568216 = path.getOrDefault("name")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "name", valid_568216
  var valid_568217 = path.getOrDefault("resourceUri")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceUri", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_DiagnosticSettingsDelete_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes existing diagnostic settings for the specified resource.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_DiagnosticSettingsDelete_568213; apiVersion: string;
          name: string; resourceUri: string): Recallable =
  ## diagnosticSettingsDelete
  ## Deletes existing diagnostic settings for the specified resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "name", newJString(name))
  add(path_568221, "resourceUri", newJString(resourceUri))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var diagnosticSettingsDelete* = Call_DiagnosticSettingsDelete_568213(
    name: "diagnosticSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsDelete_568214, base: "",
    url: url_DiagnosticSettingsDelete_568215, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
