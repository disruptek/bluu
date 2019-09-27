
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2019-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## To manage and control access to your resources, you can define customized policies and assign them at a scope.
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
  macServiceName = "resources-policyDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyDefinitionsListBuiltIn_593630 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsListBuiltIn_593632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicyDefinitionsListBuiltIn_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the built-in policy definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_PolicyDefinitionsListBuiltIn_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the built-in policy definitions.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_PolicyDefinitionsListBuiltIn_593630;
          apiVersion: string): Recallable =
  ## policyDefinitionsListBuiltIn
  ## This operation retrieves a list of all the built-in policy definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var policyDefinitionsListBuiltIn* = Call_PolicyDefinitionsListBuiltIn_593630(
    name: "policyDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListBuiltIn_593631, base: "",
    url: url_PolicyDefinitionsListBuiltIn_593632, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetBuiltIn_593926 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsGetBuiltIn_593928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGetBuiltIn_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the built-in policy definition with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the built-in policy definition to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyDefinitionName` field"
  var valid_593943 = path.getOrDefault("policyDefinitionName")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "policyDefinitionName", valid_593943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593945: Call_PolicyDefinitionsGetBuiltIn_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the built-in policy definition with the given name.
  ## 
  let valid = call_593945.validator(path, query, header, formData, body)
  let scheme = call_593945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593945.url(scheme.get, call_593945.host, call_593945.base,
                         call_593945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593945, url, valid)

proc call*(call_593946: Call_PolicyDefinitionsGetBuiltIn_593926;
          apiVersion: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetBuiltIn
  ## This operation retrieves the built-in policy definition with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the built-in policy definition to get.
  var path_593947 = newJObject()
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(path_593947, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_593946.call(path_593947, query_593948, nil, nil, nil)

var policyDefinitionsGetBuiltIn* = Call_PolicyDefinitionsGetBuiltIn_593926(
    name: "policyDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetBuiltIn_593927, base: "",
    url: url_PolicyDefinitionsGetBuiltIn_593928, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsListByManagementGroup_593949 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsListByManagementGroup_593951(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsListByManagementGroup_593950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_593952 = path.getOrDefault("managementGroupId")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "managementGroupId", valid_593952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593953 = query.getOrDefault("api-version")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "api-version", valid_593953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593954: Call_PolicyDefinitionsListByManagementGroup_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ## 
  let valid = call_593954.validator(path, query, header, formData, body)
  let scheme = call_593954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593954.url(scheme.get, call_593954.host, call_593954.base,
                         call_593954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593954, url, valid)

proc call*(call_593955: Call_PolicyDefinitionsListByManagementGroup_593949;
          apiVersion: string; managementGroupId: string): Recallable =
  ## policyDefinitionsListByManagementGroup
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_593956 = newJObject()
  var query_593957 = newJObject()
  add(query_593957, "api-version", newJString(apiVersion))
  add(path_593956, "managementGroupId", newJString(managementGroupId))
  result = call_593955.call(path_593956, query_593957, nil, nil, nil)

var policyDefinitionsListByManagementGroup* = Call_PolicyDefinitionsListByManagementGroup_593949(
    name: "policyDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListByManagementGroup_593950, base: "",
    url: url_PolicyDefinitionsListByManagementGroup_593951,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593968 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593970(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593969(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_593988 = path.getOrDefault("managementGroupId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "managementGroupId", valid_593988
  var valid_593989 = path.getOrDefault("policyDefinitionName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "policyDefinitionName", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593968;
          apiVersion: string; managementGroupId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdateAtManagementGroup
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_593996 = parameters
  add(path_593994, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_593993.call(path_593994, query_593995, nil, nil, body_593996)

var policyDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593968(
    name: "policyDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593969,
    base: "", url: url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_593970,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetAtManagementGroup_593958 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsGetAtManagementGroup_593960(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGetAtManagementGroup_593959(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_593961 = path.getOrDefault("managementGroupId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "managementGroupId", valid_593961
  var valid_593962 = path.getOrDefault("policyDefinitionName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "policyDefinitionName", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_PolicyDefinitionsGetAtManagementGroup_593958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the policy definition in the given management group with the given name.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_PolicyDefinitionsGetAtManagementGroup_593958;
          apiVersion: string; managementGroupId: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetAtManagementGroup
  ## This operation retrieves the policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "managementGroupId", newJString(managementGroupId))
  add(path_593966, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var policyDefinitionsGetAtManagementGroup* = Call_PolicyDefinitionsGetAtManagementGroup_593958(
    name: "policyDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetAtManagementGroup_593959, base: "",
    url: url_PolicyDefinitionsGetAtManagementGroup_593960, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDeleteAtManagementGroup_593997 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsDeleteAtManagementGroup_593999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsDeleteAtManagementGroup_593998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_594000 = path.getOrDefault("managementGroupId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "managementGroupId", valid_594000
  var valid_594001 = path.getOrDefault("policyDefinitionName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "policyDefinitionName", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_PolicyDefinitionsDeleteAtManagementGroup_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation deletes the policy definition in the given management group with the given name.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_PolicyDefinitionsDeleteAtManagementGroup_593997;
          apiVersion: string; managementGroupId: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsDeleteAtManagementGroup
  ## This operation deletes the policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "managementGroupId", newJString(managementGroupId))
  add(path_594005, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var policyDefinitionsDeleteAtManagementGroup* = Call_PolicyDefinitionsDeleteAtManagementGroup_593997(
    name: "policyDefinitionsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDeleteAtManagementGroup_593998, base: "",
    url: url_PolicyDefinitionsDeleteAtManagementGroup_593999,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsList_594007 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsList_594009(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsList_594008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_PolicyDefinitionsList_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_PolicyDefinitionsList_594007; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policyDefinitionsList
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var policyDefinitionsList* = Call_PolicyDefinitionsList_594007(
    name: "policyDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsList_594008, base: "",
    url: url_PolicyDefinitionsList_594009, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_594026 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsCreateOrUpdate_594028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsCreateOrUpdate_594027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  var valid_594030 = path.getOrDefault("policyDefinitionName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "policyDefinitionName", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_PolicyDefinitionsCreateOrUpdate_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_PolicyDefinitionsCreateOrUpdate_594026;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  var body_594037 = newJObject()
  add(query_594036, "api-version", newJString(apiVersion))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594037 = parameters
  add(path_594035, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594034.call(path_594035, query_594036, nil, nil, body_594037)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_594026(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_594027, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_594028, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_594016 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsGet_594018(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGet_594017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("policyDefinitionName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "policyDefinitionName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_PolicyDefinitionsGet_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_PolicyDefinitionsGet_594016; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_594016(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_594017, base: "",
    url: url_PolicyDefinitionsGet_594018, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_594038 = ref object of OpenApiRestCall_593408
proc url_PolicyDefinitionsDelete_594040(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsDelete_594039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  var valid_594042 = path.getOrDefault("policyDefinitionName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "policyDefinitionName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_PolicyDefinitionsDelete_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy definition in the given subscription with the given name.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_PolicyDefinitionsDelete_594038; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## This operation deletes the policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  add(path_594046, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_594038(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_594039, base: "",
    url: url_PolicyDefinitionsDelete_594040, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
