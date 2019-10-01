
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimproperties"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PropertyList_596680 = ref object of OpenApiRestCall_596458
proc url_PropertyList_596682(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PropertyList_596681(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_596829 = query.getOrDefault("api-version")
  valid_596829 = validateParameter(valid_596829, JString, required = true,
                                 default = nil)
  if valid_596829 != nil:
    section.add "api-version", valid_596829
  var valid_596830 = query.getOrDefault("$top")
  valid_596830 = validateParameter(valid_596830, JInt, required = false, default = nil)
  if valid_596830 != nil:
    section.add "$top", valid_596830
  var valid_596831 = query.getOrDefault("$skip")
  valid_596831 = validateParameter(valid_596831, JInt, required = false, default = nil)
  if valid_596831 != nil:
    section.add "$skip", valid_596831
  var valid_596832 = query.getOrDefault("$filter")
  valid_596832 = validateParameter(valid_596832, JString, required = false,
                                 default = nil)
  if valid_596832 != nil:
    section.add "$filter", valid_596832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596859: Call_PropertyList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  let valid = call_596859.validator(path, query, header, formData, body)
  let scheme = call_596859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596859.url(scheme.get, call_596859.host, call_596859.base,
                         call_596859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596859, url, valid)

proc call*(call_596930: Call_PropertyList_596680; apiVersion: string; Top: int = 0;
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
  var query_596931 = newJObject()
  add(query_596931, "api-version", newJString(apiVersion))
  add(query_596931, "$top", newJInt(Top))
  add(query_596931, "$skip", newJInt(Skip))
  add(query_596931, "$filter", newJString(Filter))
  result = call_596930.call(nil, query_596931, nil, nil, nil)

var propertyList* = Call_PropertyList_596680(name: "propertyList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/properties",
    validator: validate_PropertyList_596681, base: "", url: url_PropertyList_596682,
    schemes: {Scheme.Https})
type
  Call_PropertyCreateOrUpdate_597003 = ref object of OpenApiRestCall_596458
proc url_PropertyCreateOrUpdate_597005(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyCreateOrUpdate_597004(path: JsonNode; query: JsonNode;
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
  var valid_597023 = path.getOrDefault("propId")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "propId", valid_597023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597024 = query.getOrDefault("api-version")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "api-version", valid_597024
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

proc call*(call_597026: Call_PropertyCreateOrUpdate_597003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a property.
  ## 
  let valid = call_597026.validator(path, query, header, formData, body)
  let scheme = call_597026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597026.url(scheme.get, call_597026.host, call_597026.base,
                         call_597026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597026, url, valid)

proc call*(call_597027: Call_PropertyCreateOrUpdate_597003; apiVersion: string;
          propId: string; parameters: JsonNode): Recallable =
  ## propertyCreateOrUpdate
  ## Creates or updates a property.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_597028 = newJObject()
  var query_597029 = newJObject()
  var body_597030 = newJObject()
  add(query_597029, "api-version", newJString(apiVersion))
  add(path_597028, "propId", newJString(propId))
  if parameters != nil:
    body_597030 = parameters
  result = call_597027.call(path_597028, query_597029, nil, nil, body_597030)

var propertyCreateOrUpdate* = Call_PropertyCreateOrUpdate_597003(
    name: "propertyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/properties/{propId}", validator: validate_PropertyCreateOrUpdate_597004,
    base: "", url: url_PropertyCreateOrUpdate_597005, schemes: {Scheme.Https})
type
  Call_PropertyGet_596971 = ref object of OpenApiRestCall_596458
proc url_PropertyGet_596973(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyGet_596972(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_596997 = path.getOrDefault("propId")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "propId", valid_596997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596998 = query.getOrDefault("api-version")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "api-version", valid_596998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596999: Call_PropertyGet_596971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the property specified by its identifier.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_PropertyGet_596971; apiVersion: string; propId: string): Recallable =
  ## propertyGet
  ## Gets the details of the property specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  var path_597001 = newJObject()
  var query_597002 = newJObject()
  add(query_597002, "api-version", newJString(apiVersion))
  add(path_597001, "propId", newJString(propId))
  result = call_597000.call(path_597001, query_597002, nil, nil, nil)

var propertyGet* = Call_PropertyGet_596971(name: "propertyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/properties/{propId}",
                                        validator: validate_PropertyGet_596972,
                                        base: "", url: url_PropertyGet_596973,
                                        schemes: {Scheme.Https})
type
  Call_PropertyUpdate_597041 = ref object of OpenApiRestCall_596458
proc url_PropertyUpdate_597043(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyUpdate_597042(path: JsonNode; query: JsonNode;
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
  var valid_597054 = path.getOrDefault("propId")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "propId", valid_597054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597055 = query.getOrDefault("api-version")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "api-version", valid_597055
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597056 = header.getOrDefault("If-Match")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "If-Match", valid_597056
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

proc call*(call_597058: Call_PropertyUpdate_597041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific property.
  ## 
  let valid = call_597058.validator(path, query, header, formData, body)
  let scheme = call_597058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597058.url(scheme.get, call_597058.host, call_597058.base,
                         call_597058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597058, url, valid)

proc call*(call_597059: Call_PropertyUpdate_597041; apiVersion: string;
          propId: string; parameters: JsonNode): Recallable =
  ## propertyUpdate
  ## Updates the specific property.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_597060 = newJObject()
  var query_597061 = newJObject()
  var body_597062 = newJObject()
  add(query_597061, "api-version", newJString(apiVersion))
  add(path_597060, "propId", newJString(propId))
  if parameters != nil:
    body_597062 = parameters
  result = call_597059.call(path_597060, query_597061, nil, nil, body_597062)

var propertyUpdate* = Call_PropertyUpdate_597041(name: "propertyUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/properties/{propId}",
    validator: validate_PropertyUpdate_597042, base: "", url: url_PropertyUpdate_597043,
    schemes: {Scheme.Https})
type
  Call_PropertyDelete_597031 = ref object of OpenApiRestCall_596458
proc url_PropertyDelete_597033(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyDelete_597032(path: JsonNode; query: JsonNode;
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
  var valid_597034 = path.getOrDefault("propId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "propId", valid_597034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597035 = query.getOrDefault("api-version")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "api-version", valid_597035
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597036 = header.getOrDefault("If-Match")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "If-Match", valid_597036
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597037: Call_PropertyDelete_597031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific property from the API Management service instance.
  ## 
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_PropertyDelete_597031; apiVersion: string;
          propId: string): Recallable =
  ## propertyDelete
  ## Deletes specific property from the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   propId: string (required)
  ##         : Identifier of the property.
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "propId", newJString(propId))
  result = call_597038.call(path_597039, query_597040, nil, nil, nil)

var propertyDelete* = Call_PropertyDelete_597031(name: "propertyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/properties/{propId}",
    validator: validate_PropertyDelete_597032, base: "", url: url_PropertyDelete_597033,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
