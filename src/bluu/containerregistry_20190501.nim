
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ContainerRegistryManagementClient
## version: 2019-05-01
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "containerregistry"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Container Registry REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Container Registry REST API operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Container Registry REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ContainerRegistry/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_RegistriesCheckNameAvailability_593955 = ref object of OpenApiRestCall_593437
proc url_RegistriesCheckNameAvailability_593957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesCheckNameAvailability_593956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registryNameCheckRequest: JObject (required)
  ##                           : The object containing information for the availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_RegistriesCheckNameAvailability_593955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_RegistriesCheckNameAvailability_593955;
          apiVersion: string; subscriptionId: string;
          registryNameCheckRequest: JsonNode): Recallable =
  ## registriesCheckNameAvailability
  ## Checks whether the container registry name is available for use. The name must contain only alphanumeric characters, be globally unique, and between 5 and 50 characters in length.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryNameCheckRequest: JObject (required)
  ##                           : The object containing information for the availability request.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  var body_593979 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  if registryNameCheckRequest != nil:
    body_593979 = registryNameCheckRequest
  result = call_593976.call(path_593977, query_593978, nil, nil, body_593979)

var registriesCheckNameAvailability* = Call_RegistriesCheckNameAvailability_593955(
    name: "registriesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerRegistry/checkNameAvailability",
    validator: validate_RegistriesCheckNameAvailability_593956, base: "",
    url: url_RegistriesCheckNameAvailability_593957, schemes: {Scheme.Https})
type
  Call_RegistriesList_593980 = ref object of OpenApiRestCall_593437
proc url_RegistriesList_593982(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.ContainerRegistry/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesList_593981(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the container registries under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_RegistriesList_593980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the container registries under the specified subscription.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_RegistriesList_593980; apiVersion: string;
          subscriptionId: string): Recallable =
  ## registriesList
  ## Lists all the container registries under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var registriesList* = Call_RegistriesList_593980(name: "registriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerRegistry/registries",
    validator: validate_RegistriesList_593981, base: "", url: url_RegistriesList_593982,
    schemes: {Scheme.Https})
type
  Call_RegistriesListByResourceGroup_593989 = ref object of OpenApiRestCall_593437
proc url_RegistriesListByResourceGroup_593991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListByResourceGroup_593990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the container registries under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_RegistriesListByResourceGroup_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the container registries under the specified resource group.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_RegistriesListByResourceGroup_593989;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## registriesListByResourceGroup
  ## Lists all the container registries under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var registriesListByResourceGroup* = Call_RegistriesListByResourceGroup_593989(
    name: "registriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries",
    validator: validate_RegistriesListByResourceGroup_593990, base: "",
    url: url_RegistriesListByResourceGroup_593991, schemes: {Scheme.Https})
type
  Call_RegistriesCreate_594010 = ref object of OpenApiRestCall_593437
proc url_RegistriesCreate_594012(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesCreate_594011(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("registryName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "registryName", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registry: JObject (required)
  ##           : The parameters for creating a container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_RegistriesCreate_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a container registry with the specified parameters.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_RegistriesCreate_594010; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registry: JsonNode;
          registryName: string): Recallable =
  ## registriesCreate
  ## Creates a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registry: JObject (required)
  ##           : The parameters for creating a container registry.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  if registry != nil:
    body_594022 = registry
  add(path_594020, "registryName", newJString(registryName))
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var registriesCreate* = Call_RegistriesCreate_594010(name: "registriesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesCreate_594011, base: "",
    url: url_RegistriesCreate_594012, schemes: {Scheme.Https})
type
  Call_RegistriesGet_593999 = ref object of OpenApiRestCall_593437
proc url_RegistriesGet_594001(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesGet_594000(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("registryName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "registryName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_RegistriesGet_593999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified container registry.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_RegistriesGet_593999; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesGet
  ## Gets the properties of the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "registryName", newJString(registryName))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var registriesGet* = Call_RegistriesGet_593999(name: "registriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesGet_594000, base: "", url: url_RegistriesGet_594001,
    schemes: {Scheme.Https})
type
  Call_RegistriesUpdate_594034 = ref object of OpenApiRestCall_593437
proc url_RegistriesUpdate_594036(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesUpdate_594035(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("registryName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "registryName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registryUpdateParameters: JObject (required)
  ##                           : The parameters for updating a container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_RegistriesUpdate_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a container registry with the specified parameters.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_RegistriesUpdate_594034; resourceGroupName: string;
          registryUpdateParameters: JsonNode; apiVersion: string;
          subscriptionId: string; registryName: string): Recallable =
  ## registriesUpdate
  ## Updates a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   registryUpdateParameters: JObject (required)
  ##                           : The parameters for updating a container registry.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  if registryUpdateParameters != nil:
    body_594046 = registryUpdateParameters
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(path_594044, "registryName", newJString(registryName))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var registriesUpdate* = Call_RegistriesUpdate_594034(name: "registriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesUpdate_594035, base: "",
    url: url_RegistriesUpdate_594036, schemes: {Scheme.Https})
type
  Call_RegistriesDelete_594023 = ref object of OpenApiRestCall_593437
proc url_RegistriesDelete_594025(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesDelete_594024(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  var valid_594028 = path.getOrDefault("registryName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "registryName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_RegistriesDelete_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a container registry.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_RegistriesDelete_594023; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesDelete
  ## Deletes a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(path_594032, "resourceGroupName", newJString(resourceGroupName))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(path_594032, "registryName", newJString(registryName))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var registriesDelete* = Call_RegistriesDelete_594023(name: "registriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}",
    validator: validate_RegistriesDelete_594024, base: "",
    url: url_RegistriesDelete_594025, schemes: {Scheme.Https})
type
  Call_RegistriesImportImage_594047 = ref object of OpenApiRestCall_593437
proc url_RegistriesImportImage_594049(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/importImage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesImportImage_594048(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies an image to this container registry from the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("registryName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "registryName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters specifying the image to copy and the source container registry.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_RegistriesImportImage_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an image to this container registry from the specified container registry.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_RegistriesImportImage_594047;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string; parameters: JsonNode): Recallable =
  ## registriesImportImage
  ## Copies an image to this container registry from the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   parameters: JObject (required)
  ##             : The parameters specifying the image to copy and the source container registry.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "registryName", newJString(registryName))
  if parameters != nil:
    body_594059 = parameters
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var registriesImportImage* = Call_RegistriesImportImage_594047(
    name: "registriesImportImage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/importImage",
    validator: validate_RegistriesImportImage_594048, base: "",
    url: url_RegistriesImportImage_594049, schemes: {Scheme.Https})
type
  Call_RegistriesListCredentials_594060 = ref object of OpenApiRestCall_593437
proc url_RegistriesListCredentials_594062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/listCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListCredentials_594061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the login credentials for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("registryName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "registryName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_RegistriesListCredentials_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the login credentials for the specified container registry.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_RegistriesListCredentials_594060;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesListCredentials
  ## Lists the login credentials for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "registryName", newJString(registryName))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var registriesListCredentials* = Call_RegistriesListCredentials_594060(
    name: "registriesListCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/listCredentials",
    validator: validate_RegistriesListCredentials_594061, base: "",
    url: url_RegistriesListCredentials_594062, schemes: {Scheme.Https})
type
  Call_RegistriesListUsages_594071 = ref object of OpenApiRestCall_593437
proc url_RegistriesListUsages_594073(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/listUsages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesListUsages_594072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the quota usages for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("registryName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "registryName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_RegistriesListUsages_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the quota usages for the specified container registry.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_RegistriesListUsages_594071;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          registryName: string): Recallable =
  ## registriesListUsages
  ## Gets the quota usages for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  add(path_594080, "registryName", newJString(registryName))
  result = call_594079.call(path_594080, query_594081, nil, nil, nil)

var registriesListUsages* = Call_RegistriesListUsages_594071(
    name: "registriesListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/listUsages",
    validator: validate_RegistriesListUsages_594072, base: "",
    url: url_RegistriesListUsages_594073, schemes: {Scheme.Https})
type
  Call_RegistriesRegenerateCredential_594082 = ref object of OpenApiRestCall_593437
proc url_RegistriesRegenerateCredential_594084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/regenerateCredential")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistriesRegenerateCredential_594083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates one of the login credentials for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("registryName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "registryName", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateCredentialParameters: JObject (required)
  ##                                 : Specifies name of the password which should be regenerated -- password or password2.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_RegistriesRegenerateCredential_594082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates one of the login credentials for the specified container registry.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_RegistriesRegenerateCredential_594082;
          regenerateCredentialParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## registriesRegenerateCredential
  ## Regenerates one of the login credentials for the specified container registry.
  ##   regenerateCredentialParameters: JObject (required)
  ##                                 : Specifies name of the password which should be regenerated -- password or password2.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  var body_594094 = newJObject()
  if regenerateCredentialParameters != nil:
    body_594094 = regenerateCredentialParameters
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(path_594092, "registryName", newJString(registryName))
  result = call_594091.call(path_594092, query_594093, nil, nil, body_594094)

var registriesRegenerateCredential* = Call_RegistriesRegenerateCredential_594082(
    name: "registriesRegenerateCredential", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/regenerateCredential",
    validator: validate_RegistriesRegenerateCredential_594083, base: "",
    url: url_RegistriesRegenerateCredential_594084, schemes: {Scheme.Https})
type
  Call_ReplicationsList_594095 = ref object of OpenApiRestCall_593437
proc url_ReplicationsList_594097(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsList_594096(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all the replications for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  var valid_594100 = path.getOrDefault("registryName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "registryName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_ReplicationsList_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the replications for the specified container registry.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_ReplicationsList_594095; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## replicationsList
  ## Lists all the replications for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "registryName", newJString(registryName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var replicationsList* = Call_ReplicationsList_594095(name: "replicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications",
    validator: validate_ReplicationsList_594096, base: "",
    url: url_ReplicationsList_594097, schemes: {Scheme.Https})
type
  Call_ReplicationsCreate_594118 = ref object of OpenApiRestCall_593437
proc url_ReplicationsCreate_594120(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsCreate_594119(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a replication for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("replicationName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "replicationName", valid_594123
  var valid_594124 = path.getOrDefault("registryName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "registryName", valid_594124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replication: JObject (required)
  ##              : The parameters for creating a replication.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_ReplicationsCreate_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a replication for a container registry with the specified parameters.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_ReplicationsCreate_594118; replication: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          replicationName: string; registryName: string): Recallable =
  ## replicationsCreate
  ## Creates a replication for a container registry with the specified parameters.
  ##   replication: JObject (required)
  ##              : The parameters for creating a replication.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  var body_594131 = newJObject()
  if replication != nil:
    body_594131 = replication
  add(path_594129, "resourceGroupName", newJString(resourceGroupName))
  add(query_594130, "api-version", newJString(apiVersion))
  add(path_594129, "subscriptionId", newJString(subscriptionId))
  add(path_594129, "replicationName", newJString(replicationName))
  add(path_594129, "registryName", newJString(registryName))
  result = call_594128.call(path_594129, query_594130, nil, nil, body_594131)

var replicationsCreate* = Call_ReplicationsCreate_594118(
    name: "replicationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsCreate_594119, base: "",
    url: url_ReplicationsCreate_594120, schemes: {Scheme.Https})
type
  Call_ReplicationsGet_594106 = ref object of OpenApiRestCall_593437
proc url_ReplicationsGet_594108(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsGet_594107(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the properties of the specified replication.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("replicationName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "replicationName", valid_594111
  var valid_594112 = path.getOrDefault("registryName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "registryName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_ReplicationsGet_594106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified replication.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_ReplicationsGet_594106; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string): Recallable =
  ## replicationsGet
  ## Gets the properties of the specified replication.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  add(path_594116, "replicationName", newJString(replicationName))
  add(path_594116, "registryName", newJString(registryName))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var replicationsGet* = Call_ReplicationsGet_594106(name: "replicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsGet_594107, base: "", url: url_ReplicationsGet_594108,
    schemes: {Scheme.Https})
type
  Call_ReplicationsUpdate_594144 = ref object of OpenApiRestCall_593437
proc url_ReplicationsUpdate_594146(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsUpdate_594145(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a replication for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594147 = path.getOrDefault("resourceGroupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "resourceGroupName", valid_594147
  var valid_594148 = path.getOrDefault("subscriptionId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "subscriptionId", valid_594148
  var valid_594149 = path.getOrDefault("replicationName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "replicationName", valid_594149
  var valid_594150 = path.getOrDefault("registryName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "registryName", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replicationUpdateParameters: JObject (required)
  ##                              : The parameters for updating a replication.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_ReplicationsUpdate_594144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a replication for a container registry with the specified parameters.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ReplicationsUpdate_594144; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string; replicationUpdateParameters: JsonNode): Recallable =
  ## replicationsUpdate
  ## Updates a replication for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  ##   replicationUpdateParameters: JObject (required)
  ##                              : The parameters for updating a replication.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  add(path_594155, "replicationName", newJString(replicationName))
  add(path_594155, "registryName", newJString(registryName))
  if replicationUpdateParameters != nil:
    body_594157 = replicationUpdateParameters
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var replicationsUpdate* = Call_ReplicationsUpdate_594144(
    name: "replicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsUpdate_594145, base: "",
    url: url_ReplicationsUpdate_594146, schemes: {Scheme.Https})
type
  Call_ReplicationsDelete_594132 = ref object of OpenApiRestCall_593437
proc url_ReplicationsDelete_594134(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "replicationName" in path, "`replicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/replications/"),
               (kind: VariableSegment, value: "replicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationsDelete_594133(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a replication from a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: JString (required)
  ##                  : The name of the replication.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("replicationName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "replicationName", valid_594137
  var valid_594138 = path.getOrDefault("registryName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "registryName", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_ReplicationsDelete_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replication from a container registry.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_ReplicationsDelete_594132; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicationName: string;
          registryName: string): Recallable =
  ## replicationsDelete
  ## Deletes a replication from a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   replicationName: string (required)
  ##                  : The name of the replication.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  add(path_594142, "replicationName", newJString(replicationName))
  add(path_594142, "registryName", newJString(registryName))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var replicationsDelete* = Call_ReplicationsDelete_594132(
    name: "replicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/replications/{replicationName}",
    validator: validate_ReplicationsDelete_594133, base: "",
    url: url_ReplicationsDelete_594134, schemes: {Scheme.Https})
type
  Call_WebhooksList_594158 = ref object of OpenApiRestCall_593437
proc url_WebhooksList_594160(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksList_594159(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the webhooks for the specified container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  var valid_594163 = path.getOrDefault("registryName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "registryName", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594165: Call_WebhooksList_594158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the webhooks for the specified container registry.
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_WebhooksList_594158; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; registryName: string): Recallable =
  ## webhooksList
  ## Lists all the webhooks for the specified container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594167 = newJObject()
  var query_594168 = newJObject()
  add(path_594167, "resourceGroupName", newJString(resourceGroupName))
  add(query_594168, "api-version", newJString(apiVersion))
  add(path_594167, "subscriptionId", newJString(subscriptionId))
  add(path_594167, "registryName", newJString(registryName))
  result = call_594166.call(path_594167, query_594168, nil, nil, nil)

var webhooksList* = Call_WebhooksList_594158(name: "webhooksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks",
    validator: validate_WebhooksList_594159, base: "", url: url_WebhooksList_594160,
    schemes: {Scheme.Https})
type
  Call_WebhooksCreate_594181 = ref object of OpenApiRestCall_593437
proc url_WebhooksCreate_594183(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksCreate_594182(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a webhook for a container registry with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594184 = path.getOrDefault("resourceGroupName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "resourceGroupName", valid_594184
  var valid_594185 = path.getOrDefault("webhookName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "webhookName", valid_594185
  var valid_594186 = path.getOrDefault("subscriptionId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "subscriptionId", valid_594186
  var valid_594187 = path.getOrDefault("registryName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "registryName", valid_594187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594188 = query.getOrDefault("api-version")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "api-version", valid_594188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   webhookCreateParameters: JObject (required)
  ##                          : The parameters for creating a webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_WebhooksCreate_594181; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a webhook for a container registry with the specified parameters.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_WebhooksCreate_594181; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          webhookCreateParameters: JsonNode; registryName: string): Recallable =
  ## webhooksCreate
  ## Creates a webhook for a container registry with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   webhookCreateParameters: JObject (required)
  ##                          : The parameters for creating a webhook.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  var body_594194 = newJObject()
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "webhookName", newJString(webhookName))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  if webhookCreateParameters != nil:
    body_594194 = webhookCreateParameters
  add(path_594192, "registryName", newJString(registryName))
  result = call_594191.call(path_594192, query_594193, nil, nil, body_594194)

var webhooksCreate* = Call_WebhooksCreate_594181(name: "webhooksCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksCreate_594182, base: "", url: url_WebhooksCreate_594183,
    schemes: {Scheme.Https})
type
  Call_WebhooksGet_594169 = ref object of OpenApiRestCall_593437
proc url_WebhooksGet_594171(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksGet_594170(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594172 = path.getOrDefault("resourceGroupName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "resourceGroupName", valid_594172
  var valid_594173 = path.getOrDefault("webhookName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "webhookName", valid_594173
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  var valid_594175 = path.getOrDefault("registryName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "registryName", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_WebhooksGet_594169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified webhook.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_WebhooksGet_594169; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksGet
  ## Gets the properties of the specified webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  add(path_594179, "resourceGroupName", newJString(resourceGroupName))
  add(query_594180, "api-version", newJString(apiVersion))
  add(path_594179, "webhookName", newJString(webhookName))
  add(path_594179, "subscriptionId", newJString(subscriptionId))
  add(path_594179, "registryName", newJString(registryName))
  result = call_594178.call(path_594179, query_594180, nil, nil, nil)

var webhooksGet* = Call_WebhooksGet_594169(name: "webhooksGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
                                        validator: validate_WebhooksGet_594170,
                                        base: "", url: url_WebhooksGet_594171,
                                        schemes: {Scheme.Https})
type
  Call_WebhooksUpdate_594207 = ref object of OpenApiRestCall_593437
proc url_WebhooksUpdate_594209(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksUpdate_594208(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a webhook with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594210 = path.getOrDefault("resourceGroupName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "resourceGroupName", valid_594210
  var valid_594211 = path.getOrDefault("webhookName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "webhookName", valid_594211
  var valid_594212 = path.getOrDefault("subscriptionId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "subscriptionId", valid_594212
  var valid_594213 = path.getOrDefault("registryName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "registryName", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594214 = query.getOrDefault("api-version")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "api-version", valid_594214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   webhookUpdateParameters: JObject (required)
  ##                          : The parameters for updating a webhook.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_WebhooksUpdate_594207; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a webhook with the specified parameters.
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_WebhooksUpdate_594207; resourceGroupName: string;
          webhookUpdateParameters: JsonNode; apiVersion: string;
          webhookName: string; subscriptionId: string; registryName: string): Recallable =
  ## webhooksUpdate
  ## Updates a webhook with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookUpdateParameters: JObject (required)
  ##                          : The parameters for updating a webhook.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  var body_594220 = newJObject()
  add(path_594218, "resourceGroupName", newJString(resourceGroupName))
  if webhookUpdateParameters != nil:
    body_594220 = webhookUpdateParameters
  add(query_594219, "api-version", newJString(apiVersion))
  add(path_594218, "webhookName", newJString(webhookName))
  add(path_594218, "subscriptionId", newJString(subscriptionId))
  add(path_594218, "registryName", newJString(registryName))
  result = call_594217.call(path_594218, query_594219, nil, nil, body_594220)

var webhooksUpdate* = Call_WebhooksUpdate_594207(name: "webhooksUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksUpdate_594208, base: "", url: url_WebhooksUpdate_594209,
    schemes: {Scheme.Https})
type
  Call_WebhooksDelete_594195 = ref object of OpenApiRestCall_593437
proc url_WebhooksDelete_594197(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksDelete_594196(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a webhook from a container registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594198 = path.getOrDefault("resourceGroupName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceGroupName", valid_594198
  var valid_594199 = path.getOrDefault("webhookName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "webhookName", valid_594199
  var valid_594200 = path.getOrDefault("subscriptionId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "subscriptionId", valid_594200
  var valid_594201 = path.getOrDefault("registryName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "registryName", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_WebhooksDelete_594195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a webhook from a container registry.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_WebhooksDelete_594195; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksDelete
  ## Deletes a webhook from a container registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  add(path_594205, "resourceGroupName", newJString(resourceGroupName))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "webhookName", newJString(webhookName))
  add(path_594205, "subscriptionId", newJString(subscriptionId))
  add(path_594205, "registryName", newJString(registryName))
  result = call_594204.call(path_594205, query_594206, nil, nil, nil)

var webhooksDelete* = Call_WebhooksDelete_594195(name: "webhooksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}",
    validator: validate_WebhooksDelete_594196, base: "", url: url_WebhooksDelete_594197,
    schemes: {Scheme.Https})
type
  Call_WebhooksGetCallbackConfig_594221 = ref object of OpenApiRestCall_593437
proc url_WebhooksGetCallbackConfig_594223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/getCallbackConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksGetCallbackConfig_594222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration of service URI and custom headers for the webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594224 = path.getOrDefault("resourceGroupName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "resourceGroupName", valid_594224
  var valid_594225 = path.getOrDefault("webhookName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "webhookName", valid_594225
  var valid_594226 = path.getOrDefault("subscriptionId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "subscriptionId", valid_594226
  var valid_594227 = path.getOrDefault("registryName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "registryName", valid_594227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594228 = query.getOrDefault("api-version")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "api-version", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594229: Call_WebhooksGetCallbackConfig_594221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of service URI and custom headers for the webhook.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_WebhooksGetCallbackConfig_594221;
          resourceGroupName: string; apiVersion: string; webhookName: string;
          subscriptionId: string; registryName: string): Recallable =
  ## webhooksGetCallbackConfig
  ## Gets the configuration of service URI and custom headers for the webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  add(path_594231, "resourceGroupName", newJString(resourceGroupName))
  add(query_594232, "api-version", newJString(apiVersion))
  add(path_594231, "webhookName", newJString(webhookName))
  add(path_594231, "subscriptionId", newJString(subscriptionId))
  add(path_594231, "registryName", newJString(registryName))
  result = call_594230.call(path_594231, query_594232, nil, nil, nil)

var webhooksGetCallbackConfig* = Call_WebhooksGetCallbackConfig_594221(
    name: "webhooksGetCallbackConfig", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/getCallbackConfig",
    validator: validate_WebhooksGetCallbackConfig_594222, base: "",
    url: url_WebhooksGetCallbackConfig_594223, schemes: {Scheme.Https})
type
  Call_WebhooksListEvents_594233 = ref object of OpenApiRestCall_593437
proc url_WebhooksListEvents_594235(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/listEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksListEvents_594234(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists recent events for the specified webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594236 = path.getOrDefault("resourceGroupName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "resourceGroupName", valid_594236
  var valid_594237 = path.getOrDefault("webhookName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "webhookName", valid_594237
  var valid_594238 = path.getOrDefault("subscriptionId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "subscriptionId", valid_594238
  var valid_594239 = path.getOrDefault("registryName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "registryName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_WebhooksListEvents_594233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists recent events for the specified webhook.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_WebhooksListEvents_594233; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksListEvents
  ## Lists recent events for the specified webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "webhookName", newJString(webhookName))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(path_594243, "registryName", newJString(registryName))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var webhooksListEvents* = Call_WebhooksListEvents_594233(
    name: "webhooksListEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/listEvents",
    validator: validate_WebhooksListEvents_594234, base: "",
    url: url_WebhooksListEvents_594235, schemes: {Scheme.Https})
type
  Call_WebhooksPing_594245 = ref object of OpenApiRestCall_593437
proc url_WebhooksPing_594247(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "registryName" in path, "`registryName` is a required path parameter"
  assert "webhookName" in path, "`webhookName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerRegistry/registries/"),
               (kind: VariableSegment, value: "registryName"),
               (kind: ConstantSegment, value: "/webhooks/"),
               (kind: VariableSegment, value: "webhookName"),
               (kind: ConstantSegment, value: "/ping")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebhooksPing_594246(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers a ping event to be sent to the webhook.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   webhookName: JString (required)
  ##              : The name of the webhook.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: JString (required)
  ##               : The name of the container registry.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594248 = path.getOrDefault("resourceGroupName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "resourceGroupName", valid_594248
  var valid_594249 = path.getOrDefault("webhookName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "webhookName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("registryName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "registryName", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_WebhooksPing_594245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers a ping event to be sent to the webhook.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_WebhooksPing_594245; resourceGroupName: string;
          apiVersion: string; webhookName: string; subscriptionId: string;
          registryName: string): Recallable =
  ## webhooksPing
  ## Triggers a ping event to be sent to the webhook.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   webhookName: string (required)
  ##              : The name of the webhook.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   registryName: string (required)
  ##               : The name of the container registry.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "webhookName", newJString(webhookName))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  add(path_594255, "registryName", newJString(registryName))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var webhooksPing* = Call_WebhooksPing_594245(name: "webhooksPing",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{registryName}/webhooks/{webhookName}/ping",
    validator: validate_WebhooksPing_594246, base: "", url: url_WebhooksPing_594247,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
