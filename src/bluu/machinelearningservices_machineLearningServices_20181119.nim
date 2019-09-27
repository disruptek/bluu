
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Workspaces
## version: 2018-11-19
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Workspace resources.
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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-machineLearningServices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593663(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593662(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_OperationsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_OperationsList_593661; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Azure Machine Learning Workspaces REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var operationsList* = Call_OperationsList_593661(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningServices/operations",
    validator: validate_OperationsList_593662, base: "", url: url_OperationsList_593663,
    schemes: {Scheme.Https})
type
  Call_UsagesList_593957 = ref object of OpenApiRestCall_593439
proc url_UsagesList_593959(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_593958(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  var valid_593975 = path.getOrDefault("location")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "location", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_UsagesList_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_UsagesList_593957; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Gets the current usage information as well as limits for AML resources for given subscription and location.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  add(path_593979, "location", newJString(location))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var usagesList* = Call_UsagesList_593957(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/usages",
                                      validator: validate_UsagesList_593958,
                                      base: "", url: url_UsagesList_593959,
                                      schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_593981 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineSizesList_593983(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSizesList_593982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns supported VM Sizes in a location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("location")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "location", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_VirtualMachineSizesList_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns supported VM Sizes in a location
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_VirtualMachineSizesList_593981; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## Returns supported VM Sizes in a location
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "location", newJString(location))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_593981(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_593982, base: "",
    url: url_VirtualMachineSizesList_593983, schemes: {Scheme.Https})
type
  Call_WorkspacesListBySubscription_593991 = ref object of OpenApiRestCall_593439
proc url_WorkspacesListBySubscription_593993(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListBySubscription_593992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  var valid_593997 = query.getOrDefault("$skiptoken")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "$skiptoken", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_WorkspacesListBySubscription_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified subscription.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_WorkspacesListBySubscription_593991;
          apiVersion: string; subscriptionId: string; Skiptoken: string = ""): Recallable =
  ## workspacesListBySubscription
  ## Lists all the available machine learning workspaces under the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(query_594001, "$skiptoken", newJString(Skiptoken))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var workspacesListBySubscription* = Call_WorkspacesListBySubscription_593991(
    name: "workspacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListBySubscription_593992, base: "",
    url: url_WorkspacesListBySubscription_593993, schemes: {Scheme.Https})
type
  Call_WorkspacesListByResourceGroup_594002 = ref object of OpenApiRestCall_593439
proc url_WorkspacesListByResourceGroup_594004(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MachineLearningServices/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByResourceGroup_594003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("$skiptoken")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$skiptoken", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_WorkspacesListByResourceGroup_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified resource group.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_WorkspacesListByResourceGroup_594002;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Skiptoken: string = ""): Recallable =
  ## workspacesListByResourceGroup
  ## Lists all the available machine learning workspaces under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "resourceGroupName", newJString(resourceGroupName))
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(query_594012, "$skiptoken", newJString(Skiptoken))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var workspacesListByResourceGroup* = Call_WorkspacesListByResourceGroup_594002(
    name: "workspacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces",
    validator: validate_WorkspacesListByResourceGroup_594003, base: "",
    url: url_WorkspacesListByResourceGroup_594004, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_594024 = ref object of OpenApiRestCall_593439
proc url_WorkspacesCreateOrUpdate_594026(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  var valid_594029 = path.getOrDefault("workspaceName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "workspaceName", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_WorkspacesCreateOrUpdate_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a workspace with the specified parameters.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_WorkspacesCreateOrUpdate_594024;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  var body_594036 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594036 = parameters
  add(path_594034, "workspaceName", newJString(workspaceName))
  result = call_594033.call(path_594034, query_594035, nil, nil, body_594036)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_594024(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_594025, base: "",
    url: url_WorkspacesCreateOrUpdate_594026, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_594013 = ref object of OpenApiRestCall_593439
proc url_WorkspacesGet_594015(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_594014(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594016 = path.getOrDefault("resourceGroupName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "resourceGroupName", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("workspaceName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "workspaceName", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_WorkspacesGet_594013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_WorkspacesGet_594013; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(path_594022, "workspaceName", newJString(workspaceName))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_594013(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_594014, base: "", url: url_WorkspacesGet_594015,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_594048 = ref object of OpenApiRestCall_593439
proc url_WorkspacesUpdate_594050(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_594049(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  var valid_594070 = path.getOrDefault("workspaceName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "workspaceName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_WorkspacesUpdate_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_WorkspacesUpdate_594048; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594077 = parameters
  add(path_594075, "workspaceName", newJString(workspaceName))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var workspacesUpdate* = Call_WorkspacesUpdate_594048(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_594049, base: "",
    url: url_WorkspacesUpdate_594050, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_594037 = ref object of OpenApiRestCall_593439
proc url_WorkspacesDelete_594039(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_594038(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594040 = path.getOrDefault("resourceGroupName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroupName", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  var valid_594042 = path.getOrDefault("workspaceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "workspaceName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
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

proc call*(call_594044: Call_WorkspacesDelete_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_WorkspacesDelete_594037; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  add(path_594046, "workspaceName", newJString(workspaceName))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_594037(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_594038, base: "",
    url: url_WorkspacesDelete_594039, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListByWorkspace_594078 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeListByWorkspace_594080(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListByWorkspace_594079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets computes in specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("workspaceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "workspaceName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   $skiptoken: JString
  ##             : Continuation token for pagination.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  var valid_594085 = query.getOrDefault("$skiptoken")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "$skiptoken", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_MachineLearningComputeListByWorkspace_594078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets computes in specified workspace.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_MachineLearningComputeListByWorkspace_594078;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; Skiptoken: string = ""): Recallable =
  ## machineLearningComputeListByWorkspace
  ## Gets computes in specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   Skiptoken: string
  ##            : Continuation token for pagination.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(query_594089, "$skiptoken", newJString(Skiptoken))
  add(path_594088, "workspaceName", newJString(workspaceName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var machineLearningComputeListByWorkspace* = Call_MachineLearningComputeListByWorkspace_594078(
    name: "machineLearningComputeListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes",
    validator: validate_MachineLearningComputeListByWorkspace_594079, base: "",
    url: url_MachineLearningComputeListByWorkspace_594080, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeCreateOrUpdate_594102 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeCreateOrUpdate_594104(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeCreateOrUpdate_594103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  var valid_594107 = path.getOrDefault("computeName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "computeName", valid_594107
  var valid_594108 = path.getOrDefault("workspaceName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "workspaceName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_MachineLearningComputeCreateOrUpdate_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_MachineLearningComputeCreateOrUpdate_594102;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeCreateOrUpdate
  ## Creates or updates compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation. If your intent is to create a new compute, do a GET first to verify that it does not exist yet.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Payload with Machine Learning compute definition.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  var body_594115 = newJObject()
  add(path_594113, "resourceGroupName", newJString(resourceGroupName))
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "computeName", newJString(computeName))
  if parameters != nil:
    body_594115 = parameters
  add(path_594113, "workspaceName", newJString(workspaceName))
  result = call_594112.call(path_594113, query_594114, nil, nil, body_594115)

var machineLearningComputeCreateOrUpdate* = Call_MachineLearningComputeCreateOrUpdate_594102(
    name: "machineLearningComputeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeCreateOrUpdate_594103, base: "",
    url: url_MachineLearningComputeCreateOrUpdate_594104, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeGet_594090 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeGet_594092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeGet_594091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("computeName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "computeName", valid_594095
  var valid_594096 = path.getOrDefault("workspaceName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "workspaceName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_MachineLearningComputeGet_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_MachineLearningComputeGet_594090;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeGet
  ## Gets compute definition by its name. Any secrets (storage keys, service credentials, etc) are not returned - use 'keys' nested resource to get them.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "computeName", newJString(computeName))
  add(path_594100, "workspaceName", newJString(workspaceName))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var machineLearningComputeGet* = Call_MachineLearningComputeGet_594090(
    name: "machineLearningComputeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeGet_594091, base: "",
    url: url_MachineLearningComputeGet_594092, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeUpdate_594142 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeUpdate_594144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeUpdate_594143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594145 = path.getOrDefault("resourceGroupName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "resourceGroupName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("computeName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "computeName", valid_594147
  var valid_594148 = path.getOrDefault("workspaceName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "workspaceName", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_MachineLearningComputeUpdate_594142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_MachineLearningComputeUpdate_594142;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; parameters: JsonNode; workspaceName: string): Recallable =
  ## machineLearningComputeUpdate
  ## Updates properties of a compute. This call will overwrite a compute if it exists. This is a nonrecoverable operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   parameters: JObject (required)
  ##             : Additional parameters for cluster update.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  var body_594155 = newJObject()
  add(path_594153, "resourceGroupName", newJString(resourceGroupName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "subscriptionId", newJString(subscriptionId))
  add(path_594153, "computeName", newJString(computeName))
  if parameters != nil:
    body_594155 = parameters
  add(path_594153, "workspaceName", newJString(workspaceName))
  result = call_594152.call(path_594153, query_594154, nil, nil, body_594155)

var machineLearningComputeUpdate* = Call_MachineLearningComputeUpdate_594142(
    name: "machineLearningComputeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeUpdate_594143, base: "",
    url: url_MachineLearningComputeUpdate_594144, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeDelete_594116 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeDelete_594118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeDelete_594117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified Machine Learning compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594119 = path.getOrDefault("resourceGroupName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "resourceGroupName", valid_594119
  var valid_594120 = path.getOrDefault("subscriptionId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "subscriptionId", valid_594120
  var valid_594121 = path.getOrDefault("computeName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "computeName", valid_594121
  var valid_594122 = path.getOrDefault("workspaceName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "workspaceName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  ##   underlyingResourceAction: JString (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  var valid_594137 = query.getOrDefault("underlyingResourceAction")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = newJString("Delete"))
  if valid_594137 != nil:
    section.add "underlyingResourceAction", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_MachineLearningComputeDelete_594116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified Machine Learning compute.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_MachineLearningComputeDelete_594116;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string;
          underlyingResourceAction: string = "Delete"): Recallable =
  ## machineLearningComputeDelete
  ## Deletes specified Machine Learning compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   underlyingResourceAction: string (required)
  ##                           : Delete the underlying compute if 'Delete', or detach the underlying compute from workspace if 'Detach'.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "resourceGroupName", newJString(resourceGroupName))
  add(query_594141, "api-version", newJString(apiVersion))
  add(path_594140, "subscriptionId", newJString(subscriptionId))
  add(path_594140, "computeName", newJString(computeName))
  add(query_594141, "underlyingResourceAction",
      newJString(underlyingResourceAction))
  add(path_594140, "workspaceName", newJString(workspaceName))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var machineLearningComputeDelete* = Call_MachineLearningComputeDelete_594116(
    name: "machineLearningComputeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}",
    validator: validate_MachineLearningComputeDelete_594117, base: "",
    url: url_MachineLearningComputeDelete_594118, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListKeys_594156 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeListKeys_594158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListKeys_594157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594159 = path.getOrDefault("resourceGroupName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "resourceGroupName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  var valid_594161 = path.getOrDefault("computeName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "computeName", valid_594161
  var valid_594162 = path.getOrDefault("workspaceName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "workspaceName", valid_594162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594163 = query.getOrDefault("api-version")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "api-version", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_MachineLearningComputeListKeys_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_MachineLearningComputeListKeys_594156;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListKeys
  ## Gets secrets related to Machine Learning compute (storage keys, service credentials, etc).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  add(path_594166, "computeName", newJString(computeName))
  add(path_594166, "workspaceName", newJString(workspaceName))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var machineLearningComputeListKeys* = Call_MachineLearningComputeListKeys_594156(
    name: "machineLearningComputeListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listKeys",
    validator: validate_MachineLearningComputeListKeys_594157, base: "",
    url: url_MachineLearningComputeListKeys_594158, schemes: {Scheme.Https})
type
  Call_MachineLearningComputeListNodes_594168 = ref object of OpenApiRestCall_593439
proc url_MachineLearningComputeListNodes_594170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "computeName" in path, "`computeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/computes/"),
               (kind: VariableSegment, value: "computeName"),
               (kind: ConstantSegment, value: "/listNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineLearningComputeListNodes_594169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   computeName: JString (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594171 = path.getOrDefault("resourceGroupName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceGroupName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("computeName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "computeName", valid_594173
  var valid_594174 = path.getOrDefault("workspaceName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "workspaceName", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_MachineLearningComputeListNodes_594168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_MachineLearningComputeListNodes_594168;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          computeName: string; workspaceName: string): Recallable =
  ## machineLearningComputeListNodes
  ## Get the details (e.g IP address, port etc) of all the compute nodes in the compute.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   computeName: string (required)
  ##              : Name of the Azure Machine Learning compute.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(path_594178, "resourceGroupName", newJString(resourceGroupName))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "subscriptionId", newJString(subscriptionId))
  add(path_594178, "computeName", newJString(computeName))
  add(path_594178, "workspaceName", newJString(workspaceName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var machineLearningComputeListNodes* = Call_MachineLearningComputeListNodes_594168(
    name: "machineLearningComputeListNodes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/computes/{computeName}/listNodes",
    validator: validate_MachineLearningComputeListNodes_594169, base: "",
    url: url_MachineLearningComputeListNodes_594170, schemes: {Scheme.Https})
type
  Call_WorkspacesListKeys_594180 = ref object of OpenApiRestCall_593439
proc url_WorkspacesListKeys_594182(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListKeys_594181(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  var valid_594185 = path.getOrDefault("workspaceName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "workspaceName", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_WorkspacesListKeys_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_WorkspacesListKeys_594180; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string): Recallable =
  ## workspacesListKeys
  ## Lists all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  add(path_594189, "resourceGroupName", newJString(resourceGroupName))
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "subscriptionId", newJString(subscriptionId))
  add(path_594189, "workspaceName", newJString(workspaceName))
  result = call_594188.call(path_594189, query_594190, nil, nil, nil)

var workspacesListKeys* = Call_WorkspacesListKeys_594180(
    name: "workspacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/listKeys",
    validator: validate_WorkspacesListKeys_594181, base: "",
    url: url_WorkspacesListKeys_594182, schemes: {Scheme.Https})
type
  Call_WorkspacesResyncKeys_594191 = ref object of OpenApiRestCall_593439
proc url_WorkspacesResyncKeys_594193(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/resyncKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesResyncKeys_594192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : Name of Azure Machine Learning workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594194 = path.getOrDefault("resourceGroupName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "resourceGroupName", valid_594194
  var valid_594195 = path.getOrDefault("subscriptionId")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "subscriptionId", valid_594195
  var valid_594196 = path.getOrDefault("workspaceName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "workspaceName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of Azure Machine Learning resource provider API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_WorkspacesResyncKeys_594191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_WorkspacesResyncKeys_594191;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string): Recallable =
  ## workspacesResyncKeys
  ## Resync all the keys associated with this workspace. This includes keys for the storage account, app insights and password for container registry
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group in which workspace is located.
  ##   apiVersion: string (required)
  ##             : Version of Azure Machine Learning resource provider API.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : Name of Azure Machine Learning workspace.
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(path_594200, "workspaceName", newJString(workspaceName))
  result = call_594199.call(path_594200, query_594201, nil, nil, nil)

var workspacesResyncKeys* = Call_WorkspacesResyncKeys_594191(
    name: "workspacesResyncKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/resyncKeys",
    validator: validate_WorkspacesResyncKeys_594192, base: "",
    url: url_WorkspacesResyncKeys_594193, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
