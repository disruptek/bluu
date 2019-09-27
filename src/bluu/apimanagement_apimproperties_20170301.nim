
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Property entity associated with your Azure API Management deployment. API Management policies are a powerful capability of the system that allow the publisher to change the behavior of the API through configuration. Policies are a collection of statements that are executed sequentially on the request or response of an API. Policy statements can be constructed using literal text values, policy expressions, and properties. Each API Management service instance has a properties collection of key/value pairs that are global to the service instance. These properties can be used to manage constant string values across all API configuration and policies.
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
  macServiceName = "apimanagement-apimproperties"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PropertyList_593647 = ref object of OpenApiRestCall_593425
proc url_PropertyList_593649(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PropertyList_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
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
  ##          : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
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

proc call*(call_593826: Call_PropertyList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  let valid = call_593826.validator(path, query, header, formData, body)
  let scheme = call_593826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593826.url(scheme.get, call_593826.host, call_593826.base,
                         call_593826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593826, url, valid)

proc call*(call_593897: Call_PropertyList_593647; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## propertyList
  ## Lists a collection of properties defined within a service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
  var query_593898 = newJObject()
  add(query_593898, "api-version", newJString(apiVersion))
  add(query_593898, "$top", newJInt(Top))
  add(query_593898, "$skip", newJInt(Skip))
  add(query_593898, "$filter", newJString(Filter))
  result = call_593897.call(nil, query_593898, nil, nil, nil)

var propertyList* = Call_PropertyList_593647(name: "propertyList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/properties",
    validator: validate_PropertyList_593648, base: "", url: url_PropertyList_593649,
    schemes: {Scheme.Https})
type
  Call_PropertyCreateOrUpdate_593970 = ref object of OpenApiRestCall_593425
proc url_PropertyCreateOrUpdate_593972(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyCreateOrUpdate_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   propId: JString (required)
  ##         : Identifier of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `propId` field"
  var valid_593990 = path.getOrDefault("propId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "propId", valid_593990
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

proc call*(call_593993: Call_PropertyCreateOrUpdate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a property.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_PropertyCreateOrUpdate_593970; apiVersion: string;
          propId: string; parameters: JsonNode): Recallable =
  ## propertyCreateOrUpdate
  ## Creates or updates a property.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "propId", newJString(propId))
  if parameters != nil:
    body_593997 = parameters
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var propertyCreateOrUpdate* = Call_PropertyCreateOrUpdate_593970(
    name: "propertyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/properties/{propId}", validator: validate_PropertyCreateOrUpdate_593971,
    base: "", url: url_PropertyCreateOrUpdate_593972, schemes: {Scheme.Https})
type
  Call_PropertyGet_593938 = ref object of OpenApiRestCall_593425
proc url_PropertyGet_593940(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyGet_593939(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the property specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   propId: JString (required)
  ##         : Identifier of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `propId` field"
  var valid_593964 = path.getOrDefault("propId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "propId", valid_593964
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

proc call*(call_593966: Call_PropertyGet_593938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the property specified by its identifier.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_PropertyGet_593938; apiVersion: string; propId: string): Recallable =
  ## propertyGet
  ## Gets the details of the property specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "propId", newJString(propId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var propertyGet* = Call_PropertyGet_593938(name: "propertyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/properties/{propId}",
                                        validator: validate_PropertyGet_593939,
                                        base: "", url: url_PropertyGet_593940,
                                        schemes: {Scheme.Https})
type
  Call_PropertyUpdate_594008 = ref object of OpenApiRestCall_593425
proc url_PropertyUpdate_594010(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyUpdate_594009(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the specific property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   propId: JString (required)
  ##         : Identifier of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `propId` field"
  var valid_594021 = path.getOrDefault("propId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "propId", valid_594021
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
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
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

proc call*(call_594025: Call_PropertyUpdate_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific property.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_PropertyUpdate_594008; apiVersion: string;
          propId: string; parameters: JsonNode): Recallable =
  ## propertyUpdate
  ## Updates the specific property.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "propId", newJString(propId))
  if parameters != nil:
    body_594029 = parameters
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var propertyUpdate* = Call_PropertyUpdate_594008(name: "propertyUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/properties/{propId}",
    validator: validate_PropertyUpdate_594009, base: "", url: url_PropertyUpdate_594010,
    schemes: {Scheme.Https})
type
  Call_PropertyDelete_593998 = ref object of OpenApiRestCall_593425
proc url_PropertyDelete_594000(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyDelete_593999(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes specific property from the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   propId: JString (required)
  ##         : Identifier of the property.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `propId` field"
  var valid_594001 = path.getOrDefault("propId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "propId", valid_594001
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
  ##           : The entity state (Etag) version of the property to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
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

proc call*(call_594004: Call_PropertyDelete_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific property from the API Management service instance.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_PropertyDelete_593998; apiVersion: string;
          propId: string): Recallable =
  ## propertyDelete
  ## Deletes specific property from the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "propId", newJString(propId))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var propertyDelete* = Call_PropertyDelete_593998(name: "propertyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/properties/{propId}",
    validator: validate_PropertyDelete_593999, base: "", url: url_PropertyDelete_594000,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
