
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Group entity in your Azure API Management deployment. Groups are used to manage the visibility of products to developers. Each API Management service instance comes with the following immutable system groups whose membership is automatically managed by API Management.  - **Administrators** - Azure subscription administrators are members of this group. - **Developers** - Authenticated developer portal users fall into this group. - **Guests** - Unauthenticated developer portal users are placed into this group. In addition to these system groups, administrators can create custom groups or [leverage external groups in associated Azure Active Directory tenants](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-add-an-external-azure-active-directory-group). Custom and external groups can be used alongside system groups in giving developers visibility and access to API products. For example, you could create one custom group for developers affiliated with a specific partner organization and allow them access to the APIs from a product containing relevant APIs only. A user can be a member of more than one group.
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimgroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GroupList_593646 = ref object of OpenApiRestCall_593424
proc url_GroupList_593648(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GroupList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
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
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593795 = query.getOrDefault("api-version")
  valid_593795 = validateParameter(valid_593795, JString, required = true,
                                 default = nil)
  if valid_593795 != nil:
    section.add "api-version", valid_593795
  var valid_593796 = query.getOrDefault("$top")
  valid_593796 = validateParameter(valid_593796, JInt, required = false, default = nil)
  if valid_593796 != nil:
    section.add "$top", valid_593796
  var valid_593797 = query.getOrDefault("$skip")
  valid_593797 = validateParameter(valid_593797, JInt, required = false, default = nil)
  if valid_593797 != nil:
    section.add "$skip", valid_593797
  var valid_593798 = query.getOrDefault("$filter")
  valid_593798 = validateParameter(valid_593798, JString, required = false,
                                 default = nil)
  if valid_593798 != nil:
    section.add "$filter", valid_593798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593825: Call_GroupList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
  let valid = call_593825.validator(path, query, header, formData, body)
  let scheme = call_593825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593825.url(scheme.get, call_593825.host, call_593825.base,
                         call_593825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593825, url, valid)

proc call*(call_593896: Call_GroupList_593646; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## groupList
  ## Lists a collection of groups defined within a service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  var query_593897 = newJObject()
  add(query_593897, "api-version", newJString(apiVersion))
  add(query_593897, "$top", newJInt(Top))
  add(query_593897, "$skip", newJInt(Skip))
  add(query_593897, "$filter", newJString(Filter))
  result = call_593896.call(nil, query_593897, nil, nil, nil)

var groupList* = Call_GroupList_593646(name: "groupList", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/groups",
                                    validator: validate_GroupList_593647,
                                    base: "", url: url_GroupList_593648,
                                    schemes: {Scheme.Https})
type
  Call_GroupCreateOrUpdate_593969 = ref object of OpenApiRestCall_593424
proc url_GroupCreateOrUpdate_593971(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupCreateOrUpdate_593970(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or Updates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_593999 = path.getOrDefault("groupId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "groupId", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
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

proc call*(call_594002: Call_GroupCreateOrUpdate_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a group.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_GroupCreateOrUpdate_593969; groupId: string;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## groupCreateOrUpdate
  ## Creates or Updates a group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  var body_594006 = newJObject()
  add(path_594004, "groupId", newJString(groupId))
  add(query_594005, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594006 = parameters
  result = call_594003.call(path_594004, query_594005, nil, nil, body_594006)

var groupCreateOrUpdate* = Call_GroupCreateOrUpdate_593969(
    name: "groupCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/groups/{groupId}", validator: validate_GroupCreateOrUpdate_593970,
    base: "", url: url_GroupCreateOrUpdate_593971, schemes: {Scheme.Https})
type
  Call_GroupGet_593937 = ref object of OpenApiRestCall_593424
proc url_GroupGet_593939(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupGet_593938(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_593963 = path.getOrDefault("groupId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "groupId", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_GroupGet_593937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the group specified by its identifier.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_GroupGet_593937; groupId: string; apiVersion: string): Recallable =
  ## groupGet
  ## Gets the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(path_593967, "groupId", newJString(groupId))
  add(query_593968, "api-version", newJString(apiVersion))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var groupGet* = Call_GroupGet_593937(name: "groupGet", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/groups/{groupId}",
                                  validator: validate_GroupGet_593938, base: "",
                                  url: url_GroupGet_593939,
                                  schemes: {Scheme.Https})
type
  Call_GroupUpdate_594017 = ref object of OpenApiRestCall_593424
proc url_GroupUpdate_594019(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUpdate_594018(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594020 = path.getOrDefault("groupId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "groupId", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594022 = header.getOrDefault("If-Match")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "If-Match", valid_594022
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

proc call*(call_594024: Call_GroupUpdate_594017; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the group specified by its identifier.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_GroupUpdate_594017; groupId: string; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## groupUpdate
  ## Updates the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  var body_594028 = newJObject()
  add(path_594026, "groupId", newJString(groupId))
  add(query_594027, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594028 = parameters
  result = call_594025.call(path_594026, query_594027, nil, nil, body_594028)

var groupUpdate* = Call_GroupUpdate_594017(name: "groupUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "azure.local",
                                        route: "/groups/{groupId}",
                                        validator: validate_GroupUpdate_594018,
                                        base: "", url: url_GroupUpdate_594019,
                                        schemes: {Scheme.Https})
type
  Call_GroupDelete_594007 = ref object of OpenApiRestCall_593424
proc url_GroupDelete_594009(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupDelete_594008(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific group of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594010 = path.getOrDefault("groupId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "groupId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594012 = header.getOrDefault("If-Match")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "If-Match", valid_594012
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_GroupDelete_594007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific group of the API Management service instance.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_GroupDelete_594007; groupId: string; apiVersion: string): Recallable =
  ## groupDelete
  ## Deletes specific group of the API Management service instance.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "groupId", newJString(groupId))
  add(query_594016, "api-version", newJString(apiVersion))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var groupDelete* = Call_GroupDelete_594007(name: "groupDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "azure.local",
                                        route: "/groups/{groupId}",
                                        validator: validate_GroupDelete_594008,
                                        base: "", url: url_GroupDelete_594009,
                                        schemes: {Scheme.Https})
type
  Call_GroupUserList_594029 = ref object of OpenApiRestCall_593424
proc url_GroupUserList_594031(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserList_594030(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594032 = path.getOrDefault("groupId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "groupId", valid_594032
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
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  var valid_594034 = query.getOrDefault("$top")
  valid_594034 = validateParameter(valid_594034, JInt, required = false, default = nil)
  if valid_594034 != nil:
    section.add "$top", valid_594034
  var valid_594035 = query.getOrDefault("$skip")
  valid_594035 = validateParameter(valid_594035, JInt, required = false, default = nil)
  if valid_594035 != nil:
    section.add "$skip", valid_594035
  var valid_594036 = query.getOrDefault("$filter")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "$filter", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_GroupUserList_594029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_GroupUserList_594029; groupId: string;
          apiVersion: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## groupUserList
  ## Lists a collection of the members of the group, specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "groupId", newJString(groupId))
  add(query_594040, "api-version", newJString(apiVersion))
  add(query_594040, "$top", newJInt(Top))
  add(query_594040, "$skip", newJInt(Skip))
  add(query_594040, "$filter", newJString(Filter))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var groupUserList* = Call_GroupUserList_594029(name: "groupUserList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/groups/{groupId}/users",
    validator: validate_GroupUserList_594030, base: "", url: url_GroupUserList_594031,
    schemes: {Scheme.Https})
type
  Call_GroupUserCreate_594041 = ref object of OpenApiRestCall_593424
proc url_GroupUserCreate_594043(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserCreate_594042(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a user to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594044 = path.getOrDefault("groupId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "groupId", valid_594044
  var valid_594045 = path.getOrDefault("uid")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "uid", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_GroupUserCreate_594041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the specified group.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_GroupUserCreate_594041; groupId: string;
          apiVersion: string; uid: string): Recallable =
  ## groupUserCreate
  ## Adds a user to the specified group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(path_594049, "groupId", newJString(groupId))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "uid", newJString(uid))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var groupUserCreate* = Call_GroupUserCreate_594041(name: "groupUserCreate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/groups/{groupId}/users/{uid}", validator: validate_GroupUserCreate_594042,
    base: "", url: url_GroupUserCreate_594043, schemes: {Scheme.Https})
type
  Call_GroupUserDelete_594051 = ref object of OpenApiRestCall_593424
proc url_GroupUserDelete_594053(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserDelete_594052(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Remove existing user from existing group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_594054 = path.getOrDefault("groupId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "groupId", valid_594054
  var valid_594055 = path.getOrDefault("uid")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "uid", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594056 = query.getOrDefault("api-version")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "api-version", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_GroupUserDelete_594051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove existing user from existing group.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_GroupUserDelete_594051; groupId: string;
          apiVersion: string; uid: string): Recallable =
  ## groupUserDelete
  ## Remove existing user from existing group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(path_594059, "groupId", newJString(groupId))
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "uid", newJString(uid))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var groupUserDelete* = Call_GroupUserDelete_594051(name: "groupUserDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/groups/{groupId}/users/{uid}", validator: validate_GroupUserDelete_594052,
    base: "", url: url_GroupUserDelete_594053, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
