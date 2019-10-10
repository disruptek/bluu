
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on User entity in Azure API Management deployment. The User entity in API Management represents the developers that call the APIs of the products to which they are subscribed.
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimusers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UserList_573880 = ref object of OpenApiRestCall_573658
proc url_UserList_573882(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UserList_573881(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of registered users in the specified service instance.
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
  ##          : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574029 = query.getOrDefault("api-version")
  valid_574029 = validateParameter(valid_574029, JString, required = true,
                                 default = nil)
  if valid_574029 != nil:
    section.add "api-version", valid_574029
  var valid_574030 = query.getOrDefault("$top")
  valid_574030 = validateParameter(valid_574030, JInt, required = false, default = nil)
  if valid_574030 != nil:
    section.add "$top", valid_574030
  var valid_574031 = query.getOrDefault("$skip")
  valid_574031 = validateParameter(valid_574031, JInt, required = false, default = nil)
  if valid_574031 != nil:
    section.add "$skip", valid_574031
  var valid_574032 = query.getOrDefault("$filter")
  valid_574032 = validateParameter(valid_574032, JString, required = false,
                                 default = nil)
  if valid_574032 != nil:
    section.add "$filter", valid_574032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574059: Call_UserList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  let valid = call_574059.validator(path, query, header, formData, body)
  let scheme = call_574059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574059.url(scheme.get, call_574059.host, call_574059.base,
                         call_574059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574059, url, valid)

proc call*(call_574130: Call_UserList_573880; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## userList
  ## Lists a collection of registered users in the specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_574131 = newJObject()
  add(query_574131, "api-version", newJString(apiVersion))
  add(query_574131, "$top", newJInt(Top))
  add(query_574131, "$skip", newJInt(Skip))
  add(query_574131, "$filter", newJString(Filter))
  result = call_574130.call(nil, query_574131, nil, nil, nil)

var userList* = Call_UserList_573880(name: "userList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/users",
                                  validator: validate_UserList_573881, base: "",
                                  url: url_UserList_573882,
                                  schemes: {Scheme.Https})
type
  Call_UserCreateOrUpdate_574203 = ref object of OpenApiRestCall_573658
proc url_UserCreateOrUpdate_574205(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserCreateOrUpdate_574204(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or Updates a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574233 = path.getOrDefault("uid")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "uid", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574236: Call_UserCreateOrUpdate_574203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a user.
  ## 
  let valid = call_574236.validator(path, query, header, formData, body)
  let scheme = call_574236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574236.url(scheme.get, call_574236.host, call_574236.base,
                         call_574236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574236, url, valid)

proc call*(call_574237: Call_UserCreateOrUpdate_574203; apiVersion: string;
          parameters: JsonNode; uid: string): Recallable =
  ## userCreateOrUpdate
  ## Creates or Updates a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574238 = newJObject()
  var query_574239 = newJObject()
  var body_574240 = newJObject()
  add(query_574239, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574240 = parameters
  add(path_574238, "uid", newJString(uid))
  result = call_574237.call(path_574238, query_574239, nil, nil, body_574240)

var userCreateOrUpdate* = Call_UserCreateOrUpdate_574203(
    name: "userCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/users/{uid}", validator: validate_UserCreateOrUpdate_574204, base: "",
    url: url_UserCreateOrUpdate_574205, schemes: {Scheme.Https})
type
  Call_UserGet_574171 = ref object of OpenApiRestCall_573658
proc url_UserGet_574173(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGet_574172(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the user specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574197 = path.getOrDefault("uid")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "uid", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_UserGet_574171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the user specified by its identifier.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_UserGet_574171; apiVersion: string; uid: string): Recallable =
  ## userGet
  ## Gets the details of the user specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "uid", newJString(uid))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var userGet* = Call_UserGet_574171(name: "userGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/users/{uid}",
                                validator: validate_UserGet_574172, base: "",
                                url: url_UserGet_574173, schemes: {Scheme.Https})
type
  Call_UserUpdate_574266 = ref object of OpenApiRestCall_573658
proc url_UserUpdate_574268(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserUpdate_574267(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the user specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574269 = path.getOrDefault("uid")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "uid", valid_574269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574270 = query.getOrDefault("api-version")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "api-version", valid_574270
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574271 = header.getOrDefault("If-Match")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "If-Match", valid_574271
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

proc call*(call_574273: Call_UserUpdate_574266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the user specified by its identifier.
  ## 
  let valid = call_574273.validator(path, query, header, formData, body)
  let scheme = call_574273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574273.url(scheme.get, call_574273.host, call_574273.base,
                         call_574273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574273, url, valid)

proc call*(call_574274: Call_UserUpdate_574266; apiVersion: string;
          parameters: JsonNode; uid: string): Recallable =
  ## userUpdate
  ## Updates the details of the user specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574275 = newJObject()
  var query_574276 = newJObject()
  var body_574277 = newJObject()
  add(query_574276, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574277 = parameters
  add(path_574275, "uid", newJString(uid))
  result = call_574274.call(path_574275, query_574276, nil, nil, body_574277)

var userUpdate* = Call_UserUpdate_574266(name: "userUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local", route: "/users/{uid}",
                                      validator: validate_UserUpdate_574267,
                                      base: "", url: url_UserUpdate_574268,
                                      schemes: {Scheme.Https})
type
  Call_UserDelete_574241 = ref object of OpenApiRestCall_573658
proc url_UserDelete_574243(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserDelete_574242(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574244 = path.getOrDefault("uid")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "uid", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JString
  ##                      : Whether to delete user's subscription or not.
  ##   notify: JString
  ##         : Send an Account Closed Email notification to the User.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  var valid_574259 = query.getOrDefault("deleteSubscriptions")
  valid_574259 = validateParameter(valid_574259, JString, required = false,
                                 default = newJString("False"))
  if valid_574259 != nil:
    section.add "deleteSubscriptions", valid_574259
  var valid_574260 = query.getOrDefault("notify")
  valid_574260 = validateParameter(valid_574260, JString, required = false,
                                 default = newJString("False"))
  if valid_574260 != nil:
    section.add "notify", valid_574260
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574261 = header.getOrDefault("If-Match")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "If-Match", valid_574261
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574262: Call_UserDelete_574241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific user.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_UserDelete_574241; apiVersion: string; uid: string;
          deleteSubscriptions: string = "False"; notify: string = "False"): Recallable =
  ## userDelete
  ## Deletes specific user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   deleteSubscriptions: string
  ##                      : Whether to delete user's subscription or not.
  ##   notify: string
  ##         : Send an Account Closed Email notification to the User.
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  add(query_574265, "api-version", newJString(apiVersion))
  add(path_574264, "uid", newJString(uid))
  add(query_574265, "deleteSubscriptions", newJString(deleteSubscriptions))
  add(query_574265, "notify", newJString(notify))
  result = call_574263.call(path_574264, query_574265, nil, nil, nil)

var userDelete* = Call_UserDelete_574241(name: "userDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/users/{uid}",
                                      validator: validate_UserDelete_574242,
                                      base: "", url: url_UserDelete_574243,
                                      schemes: {Scheme.Https})
type
  Call_UserGenerateSsoUrl_574278 = ref object of OpenApiRestCall_573658
proc url_UserGenerateSsoUrl_574280(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/generateSsoUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGenerateSsoUrl_574279(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574281 = path.getOrDefault("uid")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "uid", valid_574281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574282 = query.getOrDefault("api-version")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "api-version", valid_574282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574283: Call_UserGenerateSsoUrl_574278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  let valid = call_574283.validator(path, query, header, formData, body)
  let scheme = call_574283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574283.url(scheme.get, call_574283.host, call_574283.base,
                         call_574283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574283, url, valid)

proc call*(call_574284: Call_UserGenerateSsoUrl_574278; apiVersion: string;
          uid: string): Recallable =
  ## userGenerateSsoUrl
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574285 = newJObject()
  var query_574286 = newJObject()
  add(query_574286, "api-version", newJString(apiVersion))
  add(path_574285, "uid", newJString(uid))
  result = call_574284.call(path_574285, query_574286, nil, nil, nil)

var userGenerateSsoUrl* = Call_UserGenerateSsoUrl_574278(
    name: "userGenerateSsoUrl", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/users/{uid}/generateSsoUrl", validator: validate_UserGenerateSsoUrl_574279,
    base: "", url: url_UserGenerateSsoUrl_574280, schemes: {Scheme.Https})
type
  Call_UserGroupList_574287 = ref object of OpenApiRestCall_573658
proc url_UserGroupList_574289(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGroupList_574288(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all user groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574290 = path.getOrDefault("uid")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "uid", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574291 = query.getOrDefault("api-version")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "api-version", valid_574291
  var valid_574292 = query.getOrDefault("$top")
  valid_574292 = validateParameter(valid_574292, JInt, required = false, default = nil)
  if valid_574292 != nil:
    section.add "$top", valid_574292
  var valid_574293 = query.getOrDefault("$skip")
  valid_574293 = validateParameter(valid_574293, JInt, required = false, default = nil)
  if valid_574293 != nil:
    section.add "$skip", valid_574293
  var valid_574294 = query.getOrDefault("$filter")
  valid_574294 = validateParameter(valid_574294, JString, required = false,
                                 default = nil)
  if valid_574294 != nil:
    section.add "$filter", valid_574294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574295: Call_UserGroupList_574287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user groups.
  ## 
  let valid = call_574295.validator(path, query, header, formData, body)
  let scheme = call_574295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574295.url(scheme.get, call_574295.host, call_574295.base,
                         call_574295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574295, url, valid)

proc call*(call_574296: Call_UserGroupList_574287; apiVersion: string; uid: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userGroupList
  ## Lists all user groups.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_574297 = newJObject()
  var query_574298 = newJObject()
  add(query_574298, "api-version", newJString(apiVersion))
  add(query_574298, "$top", newJInt(Top))
  add(query_574298, "$skip", newJInt(Skip))
  add(path_574297, "uid", newJString(uid))
  add(query_574298, "$filter", newJString(Filter))
  result = call_574296.call(path_574297, query_574298, nil, nil, nil)

var userGroupList* = Call_UserGroupList_574287(name: "userGroupList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/users/{uid}/groups",
    validator: validate_UserGroupList_574288, base: "", url: url_UserGroupList_574289,
    schemes: {Scheme.Https})
type
  Call_UserIdentitiesList_574299 = ref object of OpenApiRestCall_573658
proc url_UserIdentitiesList_574301(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/identities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserIdentitiesList_574300(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all user identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574302 = path.getOrDefault("uid")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "uid", valid_574302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574303 = query.getOrDefault("api-version")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "api-version", valid_574303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_UserIdentitiesList_574299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user identities.
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_UserIdentitiesList_574299; apiVersion: string;
          uid: string): Recallable =
  ## userIdentitiesList
  ## Lists all user identities.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "uid", newJString(uid))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var userIdentitiesList* = Call_UserIdentitiesList_574299(
    name: "userIdentitiesList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/users/{uid}/identities", validator: validate_UserIdentitiesList_574300,
    base: "", url: url_UserIdentitiesList_574301, schemes: {Scheme.Https})
type
  Call_UserSubscriptionList_574308 = ref object of OpenApiRestCall_573658
proc url_UserSubscriptionList_574310(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserSubscriptionList_574309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574311 = path.getOrDefault("uid")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "uid", valid_574311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574312 = query.getOrDefault("api-version")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "api-version", valid_574312
  var valid_574313 = query.getOrDefault("$top")
  valid_574313 = validateParameter(valid_574313, JInt, required = false, default = nil)
  if valid_574313 != nil:
    section.add "$top", valid_574313
  var valid_574314 = query.getOrDefault("$skip")
  valid_574314 = validateParameter(valid_574314, JInt, required = false, default = nil)
  if valid_574314 != nil:
    section.add "$skip", valid_574314
  var valid_574315 = query.getOrDefault("$filter")
  valid_574315 = validateParameter(valid_574315, JString, required = false,
                                 default = nil)
  if valid_574315 != nil:
    section.add "$filter", valid_574315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574316: Call_UserSubscriptionList_574308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  let valid = call_574316.validator(path, query, header, formData, body)
  let scheme = call_574316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574316.url(scheme.get, call_574316.host, call_574316.base,
                         call_574316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574316, url, valid)

proc call*(call_574317: Call_UserSubscriptionList_574308; apiVersion: string;
          uid: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userSubscriptionList
  ## Lists the collection of subscriptions of the specified user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_574318 = newJObject()
  var query_574319 = newJObject()
  add(query_574319, "api-version", newJString(apiVersion))
  add(query_574319, "$top", newJInt(Top))
  add(query_574319, "$skip", newJInt(Skip))
  add(path_574318, "uid", newJString(uid))
  add(query_574319, "$filter", newJString(Filter))
  result = call_574317.call(path_574318, query_574319, nil, nil, nil)

var userSubscriptionList* = Call_UserSubscriptionList_574308(
    name: "userSubscriptionList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/users/{uid}/subscriptions", validator: validate_UserSubscriptionList_574309,
    base: "", url: url_UserSubscriptionList_574310, schemes: {Scheme.Https})
type
  Call_UserGetSharedAccessToken_574320 = ref object of OpenApiRestCall_573658
proc url_UserGetSharedAccessToken_574322(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetSharedAccessToken_574321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Shared Access Authorization Token for the User.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uid` field"
  var valid_574323 = path.getOrDefault("uid")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "uid", valid_574323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574324 = query.getOrDefault("api-version")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "api-version", valid_574324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create Authorization Token parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_UserGetSharedAccessToken_574320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Shared Access Authorization Token for the User.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_UserGetSharedAccessToken_574320; apiVersion: string;
          parameters: JsonNode; uid: string): Recallable =
  ## userGetSharedAccessToken
  ## Gets the Shared Access Authorization Token for the User.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create Authorization Token parameters.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  var body_574330 = newJObject()
  add(query_574329, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574330 = parameters
  add(path_574328, "uid", newJString(uid))
  result = call_574327.call(path_574328, query_574329, nil, nil, body_574330)

var userGetSharedAccessToken* = Call_UserGetSharedAccessToken_574320(
    name: "userGetSharedAccessToken", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/users/{uid}/token",
    validator: validate_UserGetSharedAccessToken_574321, base: "",
    url: url_UserGetSharedAccessToken_574322, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
