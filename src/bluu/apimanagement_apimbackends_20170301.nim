
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Backend entity in Azure API Management deployment. The Backend entity in API Management represents a backend service that is configured to skip certification chain validation when using a self-signed certificate to test mutual certificate authentication.
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimbackends"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackendList_593647 = ref object of OpenApiRestCall_593425
proc url_BackendList_593649(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BackendList_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of backends in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593796 = query.getOrDefault("api-version")
  valid_593796 = validateParameter(valid_593796, JString, required = true,
                                 default = nil)
  if valid_593796 != nil:
    section.add "api-version", valid_593796
  var valid_593797 = query.getOrDefault("$top")
  valid_593797 = validateParameter(valid_593797, JInt, required = false, default = nil)
  if valid_593797 != nil:
    section.add "$top", valid_593797
  var valid_593798 = query.getOrDefault("$skip")
  valid_593798 = validateParameter(valid_593798, JInt, required = false, default = nil)
  if valid_593798 != nil:
    section.add "$skip", valid_593798
  var valid_593799 = query.getOrDefault("$filter")
  valid_593799 = validateParameter(valid_593799, JString, required = false,
                                 default = nil)
  if valid_593799 != nil:
    section.add "$filter", valid_593799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593826: Call_BackendList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of backends in the specified service instance.
  ## 
  let valid = call_593826.validator(path, query, header, formData, body)
  let scheme = call_593826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593826.url(scheme.get, call_593826.host, call_593826.base,
                         call_593826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593826, url, valid)

proc call*(call_593897: Call_BackendList_593647; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## backendList
  ## Lists a collection of backends in the specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_593898 = newJObject()
  add(query_593898, "api-version", newJString(apiVersion))
  add(query_593898, "$top", newJInt(Top))
  add(query_593898, "$skip", newJInt(Skip))
  add(query_593898, "$filter", newJString(Filter))
  result = call_593897.call(nil, query_593898, nil, nil, nil)

var backendList* = Call_BackendList_593647(name: "backendList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/backends",
                                        validator: validate_BackendList_593648,
                                        base: "", url: url_BackendList_593649,
                                        schemes: {Scheme.Https})
type
  Call_BackendCreateOrUpdate_593970 = ref object of OpenApiRestCall_593425
proc url_BackendCreateOrUpdate_593972(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendCreateOrUpdate_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `backendid` field"
  var valid_593990 = path.getOrDefault("backendid")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "backendid", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_BackendCreateOrUpdate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a backend.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_BackendCreateOrUpdate_593970; backendid: string;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## backendCreateOrUpdate
  ## Creates or Updates a backend.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(path_593995, "backendid", newJString(backendid))
  add(query_593996, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593997 = parameters
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var backendCreateOrUpdate* = Call_BackendCreateOrUpdate_593970(
    name: "backendCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/backends/{backendid}", validator: validate_BackendCreateOrUpdate_593971,
    base: "", url: url_BackendCreateOrUpdate_593972, schemes: {Scheme.Https})
type
  Call_BackendGet_593938 = ref object of OpenApiRestCall_593425
proc url_BackendGet_593940(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendGet_593939(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backend specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `backendid` field"
  var valid_593964 = path.getOrDefault("backendid")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "backendid", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_BackendGet_593938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backend specified by its identifier.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_BackendGet_593938; backendid: string; apiVersion: string): Recallable =
  ## backendGet
  ## Gets the details of the backend specified by its identifier.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "backendid", newJString(backendid))
  add(query_593969, "api-version", newJString(apiVersion))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var backendGet* = Call_BackendGet_593938(name: "backendGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/backends/{backendid}",
                                      validator: validate_BackendGet_593939,
                                      base: "", url: url_BackendGet_593940,
                                      schemes: {Scheme.Https})
type
  Call_BackendUpdate_594008 = ref object of OpenApiRestCall_593425
proc url_BackendUpdate_594010(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendUpdate_594009(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `backendid` field"
  var valid_594021 = path.getOrDefault("backendid")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "backendid", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594023 = header.getOrDefault("If-Match")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "If-Match", valid_594023
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_BackendUpdate_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing backend.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_BackendUpdate_594008; backendid: string;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## backendUpdate
  ## Updates an existing backend.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(path_594027, "backendid", newJString(backendid))
  add(query_594028, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594029 = parameters
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var backendUpdate* = Call_BackendUpdate_594008(name: "backendUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/backends/{backendid}",
    validator: validate_BackendUpdate_594009, base: "", url: url_BackendUpdate_594010,
    schemes: {Scheme.Https})
type
  Call_BackendDelete_593998 = ref object of OpenApiRestCall_593425
proc url_BackendDelete_594000(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendDelete_593999(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `backendid` field"
  var valid_594001 = path.getOrDefault("backendid")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "backendid", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594003 = header.getOrDefault("If-Match")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "If-Match", valid_594003
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_BackendDelete_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backend.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_BackendDelete_593998; backendid: string;
          apiVersion: string): Recallable =
  ## backendDelete
  ## Deletes the specified backend.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "backendid", newJString(backendid))
  add(query_594007, "api-version", newJString(apiVersion))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var backendDelete* = Call_BackendDelete_593998(name: "backendDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/backends/{backendid}", validator: validate_BackendDelete_593999,
    base: "", url: url_BackendDelete_594000, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
