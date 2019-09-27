
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AuthorizationManagementClient
## version: 2018-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Role based access control provides you a way to apply granular level policy administration down to individual resources or resource groups. These calls handle provider operations.
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
  macServiceName = "authorization-authorization-ProviderOperationsCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsMetadataList_593630 = ref object of OpenApiRestCall_593408
proc url_ProviderOperationsMetadataList_593632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsMetadataList_593631(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets provider operations metadata for all resource providers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Specifies whether to expand the values.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  var valid_593806 = query.getOrDefault("$expand")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_593806 != nil:
    section.add "$expand", valid_593806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593829: Call_ProviderOperationsMetadataList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for all resource providers.
  ## 
  let valid = call_593829.validator(path, query, header, formData, body)
  let scheme = call_593829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593829.url(scheme.get, call_593829.host, call_593829.base,
                         call_593829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593829, url, valid)

proc call*(call_593900: Call_ProviderOperationsMetadataList_593630;
          apiVersion: string; Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataList
  ## Gets provider operations metadata for all resource providers.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  var query_593901 = newJObject()
  add(query_593901, "api-version", newJString(apiVersion))
  add(query_593901, "$expand", newJString(Expand))
  result = call_593900.call(nil, query_593901, nil, nil, nil)

var providerOperationsMetadataList* = Call_ProviderOperationsMetadataList_593630(
    name: "providerOperationsMetadataList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/providerOperations",
    validator: validate_ProviderOperationsMetadataList_593631, base: "",
    url: url_ProviderOperationsMetadataList_593632, schemes: {Scheme.Https})
type
  Call_ProviderOperationsMetadataGet_593941 = ref object of OpenApiRestCall_593408
proc url_ProviderOperationsMetadataGet_593943(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Authorization/providerOperations/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderOperationsMetadataGet_593942(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets provider operations metadata for the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_593958 = path.getOrDefault("resourceProviderNamespace")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "resourceProviderNamespace", valid_593958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Specifies whether to expand the values.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  var valid_593960 = query.getOrDefault("$expand")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_593960 != nil:
    section.add "$expand", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_ProviderOperationsMetadataGet_593941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for the specified resource provider.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_ProviderOperationsMetadataGet_593941;
          apiVersion: string; resourceProviderNamespace: string;
          Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataGet
  ## Gets provider operations metadata for the specified resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(query_593964, "$expand", newJString(Expand))
  add(path_593963, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var providerOperationsMetadataGet* = Call_ProviderOperationsMetadataGet_593941(
    name: "providerOperationsMetadataGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/providerOperations/{resourceProviderNamespace}",
    validator: validate_ProviderOperationsMetadataGet_593942, base: "",
    url: url_ProviderOperationsMetadataGet_593943, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
