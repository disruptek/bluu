
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2016-09-01
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
  macServiceName = "monitor-serviceDiagnosticsSettings_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceDiagnosticSettingsCreateOrUpdate_568192 = ref object of OpenApiRestCall_567658
proc url_ServiceDiagnosticSettingsCreateOrUpdate_568194(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/service")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceDiagnosticSettingsCreateOrUpdate_568193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update new diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ServiceDiagnosticSettingsCreateOrUpdate_568192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update new diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ServiceDiagnosticSettingsCreateOrUpdate_568192;
          apiVersion: string; resourceUri: string; parameters: JsonNode): Recallable =
  ## serviceDiagnosticSettingsCreateOrUpdate
  ## Create or update new diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  var body_568202 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_568202 = parameters
  result = call_568199.call(path_568200, query_568201, nil, nil, body_568202)

var serviceDiagnosticSettingsCreateOrUpdate* = Call_ServiceDiagnosticSettingsCreateOrUpdate_568192(
    name: "serviceDiagnosticSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsCreateOrUpdate_568193, base: "",
    url: url_ServiceDiagnosticSettingsCreateOrUpdate_568194,
    schemes: {Scheme.Https})
type
  Call_ServiceDiagnosticSettingsGet_567880 = ref object of OpenApiRestCall_567658
proc url_ServiceDiagnosticSettingsGet_567882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/service")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceDiagnosticSettingsGet_567881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the active diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568055 = path.getOrDefault("resourceUri")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceUri", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_ServiceDiagnosticSettingsGet_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_ServiceDiagnosticSettingsGet_567880;
          apiVersion: string; resourceUri: string): Recallable =
  ## serviceDiagnosticSettingsGet
  ## Gets the active diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_568151 = newJObject()
  var query_568153 = newJObject()
  add(query_568153, "api-version", newJString(apiVersion))
  add(path_568151, "resourceUri", newJString(resourceUri))
  result = call_568150.call(path_568151, query_568153, nil, nil, nil)

var serviceDiagnosticSettingsGet* = Call_ServiceDiagnosticSettingsGet_567880(
    name: "serviceDiagnosticSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsGet_567881, base: "",
    url: url_ServiceDiagnosticSettingsGet_567882, schemes: {Scheme.Https})
type
  Call_ServiceDiagnosticSettingsUpdate_568203 = ref object of OpenApiRestCall_567658
proc url_ServiceDiagnosticSettingsUpdate_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/diagnosticSettings/service")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceDiagnosticSettingsUpdate_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing ServiceDiagnosticSettingsResource. To update other fields use the CreateOrUpdate method. **WARNING**: This method will be deprecated in future releases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568223 = path.getOrDefault("resourceUri")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceUri", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceDiagnosticSettingsResource: JObject (required)
  ##                                    : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_ServiceDiagnosticSettingsUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing ServiceDiagnosticSettingsResource. To update other fields use the CreateOrUpdate method. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_ServiceDiagnosticSettingsUpdate_568203;
          apiVersion: string; serviceDiagnosticSettingsResource: JsonNode;
          resourceUri: string): Recallable =
  ## serviceDiagnosticSettingsUpdate
  ## Updates an existing ServiceDiagnosticSettingsResource. To update other fields use the CreateOrUpdate method. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serviceDiagnosticSettingsResource: JObject (required)
  ##                                    : Parameters supplied to the operation.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  var body_568230 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  if serviceDiagnosticSettingsResource != nil:
    body_568230 = serviceDiagnosticSettingsResource
  add(path_568228, "resourceUri", newJString(resourceUri))
  result = call_568227.call(path_568228, query_568229, nil, nil, body_568230)

var serviceDiagnosticSettingsUpdate* = Call_ServiceDiagnosticSettingsUpdate_568203(
    name: "serviceDiagnosticSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsUpdate_568204, base: "",
    url: url_ServiceDiagnosticSettingsUpdate_568205, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
