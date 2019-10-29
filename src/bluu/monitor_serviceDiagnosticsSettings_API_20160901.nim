
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "monitor-serviceDiagnosticsSettings_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceDiagnosticSettingsCreateOrUpdate_564092 = ref object of OpenApiRestCall_563556
proc url_ServiceDiagnosticSettingsCreateOrUpdate_564094(protocol: Scheme;
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

proc validate_ServiceDiagnosticSettingsCreateOrUpdate_564093(path: JsonNode;
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
  var valid_564095 = path.getOrDefault("resourceUri")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceUri", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
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

proc call*(call_564098: Call_ServiceDiagnosticSettingsCreateOrUpdate_564092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update new diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_ServiceDiagnosticSettingsCreateOrUpdate_564092;
          apiVersion: string; resourceUri: string; parameters: JsonNode): Recallable =
  ## serviceDiagnosticSettingsCreateOrUpdate
  ## Create or update new diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  var body_564102 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_564102 = parameters
  result = call_564099.call(path_564100, query_564101, nil, nil, body_564102)

var serviceDiagnosticSettingsCreateOrUpdate* = Call_ServiceDiagnosticSettingsCreateOrUpdate_564092(
    name: "serviceDiagnosticSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsCreateOrUpdate_564093, base: "",
    url: url_ServiceDiagnosticSettingsCreateOrUpdate_564094,
    schemes: {Scheme.Https})
type
  Call_ServiceDiagnosticSettingsGet_563778 = ref object of OpenApiRestCall_563556
proc url_ServiceDiagnosticSettingsGet_563780(protocol: Scheme; host: string;
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

proc validate_ServiceDiagnosticSettingsGet_563779(path: JsonNode; query: JsonNode;
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
  var valid_563955 = path.getOrDefault("resourceUri")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "resourceUri", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_ServiceDiagnosticSettingsGet_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_ServiceDiagnosticSettingsGet_563778;
          apiVersion: string; resourceUri: string): Recallable =
  ## serviceDiagnosticSettingsGet
  ## Gets the active diagnostic settings for the specified resource. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  var path_564051 = newJObject()
  var query_564053 = newJObject()
  add(query_564053, "api-version", newJString(apiVersion))
  add(path_564051, "resourceUri", newJString(resourceUri))
  result = call_564050.call(path_564051, query_564053, nil, nil, nil)

var serviceDiagnosticSettingsGet* = Call_ServiceDiagnosticSettingsGet_563778(
    name: "serviceDiagnosticSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsGet_563779, base: "",
    url: url_ServiceDiagnosticSettingsGet_563780, schemes: {Scheme.Https})
type
  Call_ServiceDiagnosticSettingsUpdate_564103 = ref object of OpenApiRestCall_563556
proc url_ServiceDiagnosticSettingsUpdate_564105(protocol: Scheme; host: string;
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

proc validate_ServiceDiagnosticSettingsUpdate_564104(path: JsonNode;
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
  var valid_564123 = path.getOrDefault("resourceUri")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceUri", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
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

proc call*(call_564126: Call_ServiceDiagnosticSettingsUpdate_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing ServiceDiagnosticSettingsResource. To update other fields use the CreateOrUpdate method. **WARNING**: This method will be deprecated in future releases.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_ServiceDiagnosticSettingsUpdate_564103;
          apiVersion: string; resourceUri: string;
          serviceDiagnosticSettingsResource: JsonNode): Recallable =
  ## serviceDiagnosticSettingsUpdate
  ## Updates an existing ServiceDiagnosticSettingsResource. To update other fields use the CreateOrUpdate method. **WARNING**: This method will be deprecated in future releases.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The identifier of the resource.
  ##   serviceDiagnosticSettingsResource: JObject (required)
  ##                                    : Parameters supplied to the operation.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "resourceUri", newJString(resourceUri))
  if serviceDiagnosticSettingsResource != nil:
    body_564130 = serviceDiagnosticSettingsResource
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var serviceDiagnosticSettingsUpdate* = Call_ServiceDiagnosticSettingsUpdate_564103(
    name: "serviceDiagnosticSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/diagnosticSettings/service",
    validator: validate_ServiceDiagnosticSettingsUpdate_564104, base: "",
    url: url_ServiceDiagnosticSettingsUpdate_564105, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
